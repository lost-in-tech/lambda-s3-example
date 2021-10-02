using Microsoft.Extensions.DependencyInjection;
using System;
using Xunit;

namespace LambdaForS3.Tests.Infra
{
    public class IocFixture
    {
        private IServiceProvider sp;

        public IocFixture()
        {
            var services = new ServiceCollection();

            FakeSetup.Run(services);

            sp = services.BuildServiceProvider();
        }

        public IServiceScope Scope() => sp.CreateScope();
    }

    [CollectionDefinition(nameof(IocFixtureCollection))]
    public class IocFixtureCollection : ICollectionFixture<IocFixture>
    {
    }

    [Collection(nameof(IocFixtureCollection))]
    public class TestWithIocFixture : IDisposable
    {
        private readonly IocFixture fixture;
        private IServiceScope scope;

        public TestWithIocFixture(IocFixture fixture)
        {
            this.fixture = fixture;
            scope = fixture.Scope();
        }

        public void Dispose()
        {
            scope?.Dispose();
        }
    }
}
