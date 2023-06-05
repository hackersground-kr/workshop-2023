using WebApi.Models;

namespace WebApi.Extensions
{
    public static class DictionaryExtensions
    {
        public static T ToObject<T>(this IHeaderDictionary headers) where T : ApiRequestHeaders
        {
            var result = Activator.CreateInstance<T>();
            foreach (var header in headers)
            {
                switch (header.Key)
                {
                    case "x-webapi-key":
                        result.ApiKey = header.Value;
                        break;

                    case "x-github-token":
                        (result as GitHubApiRequestHeaders).GitHubToken = header.Value;
                        break;
                }
            }

            return result;
        }
    }
}