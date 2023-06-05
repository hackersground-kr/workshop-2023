using System.Text.Json.Serialization;

namespace WebApi.Models
{
    public abstract class ApiRequestHeaders
    {
        [JsonPropertyName("x-webapi-key")]
        public virtual string? ApiKey { get; set; }
    }
}