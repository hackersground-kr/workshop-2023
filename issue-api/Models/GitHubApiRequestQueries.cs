using System.ComponentModel.DataAnnotations;

namespace WebApi.Models
{
    public class GitHubApiRequestQueries : ApiRequestQueries
    {
        [Required]
        public virtual string? User { get; set; }

        [Required]
        public virtual string? Repository { get; set; }
    }
}