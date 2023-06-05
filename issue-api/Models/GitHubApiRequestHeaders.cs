using System.Text.Json.Serialization;

namespace WebApi.Models
{
    public class GitHubApiRequestHeaders : ApiRequestHeaders
    {
        [JsonPropertyName("x-github-token")]
        public virtual string? GitHubToken { get; set; }
    }
}