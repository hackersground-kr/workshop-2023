using Microsoft.AspNetCore.Mvc;

using WebApi.Configurations;
using WebApi.Extensions;
using WebApi.Models;

namespace WebApi.Services
{
    public interface IValidationService
    {
        HeaderValidationResult<T> ValidateHeaders<T>(IHeaderDictionary requestHeaders) where T : ApiRequestHeaders;

        QueryValidationResult<T> ValidateQueries<T>(T requestQueries) where T : ApiRequestQueries;
    }

    public class ValidationService : IValidationService
    {
        private readonly AuthSettings _settings;

        public ValidationService(AuthSettings settings)
        {
            this._settings = settings ?? throw new ArgumentNullException(nameof(settings));
        }

        public HeaderValidationResult<T> ValidateHeaders<T>(IHeaderDictionary requestHeaders) where T : ApiRequestHeaders
        {
            var headers = requestHeaders.ToObject<T>();
            var result = new HeaderValidationResult<T>() { Headers = headers };
#if !DEBUG
            var apiKey = headers.ApiKey;
            if (string.IsNullOrWhiteSpace(apiKey) == true)
            {
                var error = new ErrorResponse() { Message = "Invalid API Key" };
                result.ActionResult = new UnauthorizedObjectResult(error);

                return result;
            }
#endif
            if (headers is not GitHubApiRequestHeaders)
            {
                result.Validated = true;

                return result;
            }

            var gitHubToken = (headers as GitHubApiRequestHeaders).GitHubToken;

            if (string.IsNullOrWhiteSpace(gitHubToken) == true)
            {
                var error = new ErrorResponse() { Message = "Invalid GitHub Token" };
                result.ActionResult = new ObjectResult(error) { StatusCode = StatusCodes.Status403Forbidden };

                return result;
            }

            result.Validated = true;

            return result;
        }

        public QueryValidationResult<T> ValidateQueries<T>(T requestQueries) where T : ApiRequestQueries
        {
            var result = new QueryValidationResult<T>() { Queries = requestQueries };
            if (requestQueries is not GitHubApiRequestQueries)
            {
                result.Validated = true;

                return result;
            }

            var queries = requestQueries as GitHubApiRequestQueries;
            if (string.IsNullOrWhiteSpace(queries.User))
            {
                var error = new ErrorResponse() { Message = "No GitHub details found" };
                result.ActionResult = new ObjectResult(error) { StatusCode = StatusCodes.Status404NotFound };

                return result;
            }

            if (string.IsNullOrWhiteSpace(queries.Repository))
            {
                var error = new ErrorResponse() { Message = "No GitHub details found" };
                result.ActionResult = new ObjectResult(error) { StatusCode = StatusCodes.Status404NotFound };

                return result;
            }

            result.Validated = true;

            return result;
        }
    }
}
