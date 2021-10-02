using Bolt.Common.Extensions;
using Newtonsoft.Json;
using Shouldly;

namespace LambdaForS3.Tests.Infra
{
    public static class ShouldExtensions
    {
        public static void ShouldMatchApprovedDefault(this string source, string customMessage = null, string discriminator = null)
        {
            source.ShouldMatchApproved(opt => BuildDefault(opt, discriminator), customMessage);
        }

        public static void ShouldMatchApprovedDefault<T>(this T source, string customMessage = null, string discriminator = null)
        {
            ToPrettyJson(source)
                .ShouldMatchApproved(opt => BuildDefault(opt, discriminator), customMessage);
        }

        private static void BuildDefault(Shouldly.Configuration.ShouldMatchConfigurationBuilder builder, string discriminator = null)
        {
            builder.UseCallerLocation();

            if(discriminator != null)
            {
                builder.WithDiscriminator(discriminator);
            }

            builder.SubFolder("approvals");
        }

        
        private static string ToPrettyJson(object value)
        {
            if (value == null) return null;

            return JsonConvert.SerializeObject(value, Formatting.Indented);
        }
    }
}
