using Octokit;

using WebApi.Configurations;
using WebApi.Models;

namespace WebApi.Services
{
    public interface IGitHubService
    {
        Task<GitHubIssueCollectionResponse> GetIssuesAsync(GitHubApiRequestHeaders headers, GitHubApiRequestQueries req);

        Task<GitHubIssueItemResponse> GetIssueAsync(int id, GitHubApiRequestHeaders headers, GitHubApiRequestQueries req);
    }

    public class GitHubService : IGitHubService
    {
        private readonly GitHubSettings _settings;

        public GitHubService(GitHubSettings settings)
        {
            this._settings = settings ?? throw new ArgumentNullException(nameof(settings));
        }

        public async Task<GitHubIssueCollectionResponse> GetIssuesAsync(GitHubApiRequestHeaders headers, GitHubApiRequestQueries req)
        {
            var user = req.User;
            var repository = req.Repository;

            var github = this.GetGitHubClient(headers);

            var issues = await github.Issue.GetAllForRepository(user, repository);
            var res = new GitHubIssueCollectionResponse()
            {
                Items = issues.Select(p => new GitHubIssueItemResponse()
                {
                    Id = p.Id,
                    Number = p.Number,
                    Title = p.Title,
                    Body = p.Body,
                })
            };

            return res;
        }

        public async Task<GitHubIssueItemResponse> GetIssueAsync(int id, GitHubApiRequestHeaders headers, GitHubApiRequestQueries req)
        {
            var user = req.User;
            var repository = req.Repository;

            var github = this.GetGitHubClient(headers);

            var issue = await github.Issue.Get(user, repository, id);
            var res = new GitHubIssueItemResponse()
            {
                Id = issue.Id,
                Number = issue.Number,
                Title = issue.Title,
                Body = issue.Body,
            };

            return res;
        }

        private IGitHubClient GetGitHubClient(GitHubApiRequestHeaders headers)
        {
            var accessToken = headers.GitHubToken;
            var credentials = new Credentials(accessToken, AuthenticationType.Bearer);
            var agent = this._settings.Agent.Replace(" ", "").Trim();
            var github = new GitHubClient(new ProductHeaderValue(agent))
            {
                Credentials = credentials
            };

            return github;
        }
    }
}
