using System.Collections.Generic;
using System.Linq;

namespace LambdaForS3.Tests.Infra
{
    public static class TestDataExtensions
    {
        public static IEnumerable<object[]> ToTestData<T>(this IEnumerable<T> source)
        {
            if (source == null) return Enumerable.Empty<object[]>();

            var result = new List<object[]>();

            foreach(var item in source)
            {
                result.Add(new object[]
                {
                    item
                });
            }

            return result;
        }
    }
}
