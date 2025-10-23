using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TestSURAConcept
{
    public class TestProgram
    {
        [Fact]
        public void Program_CanBuildApplicationSuccessfully()
        {
            // Arrange
            var builder = WebApplication.CreateBuilder(new string[] { });

            // Act
            builder.Services.AddControllers();
            builder.Services.AddOpenApi();
            builder.Services.AddSingleton<SURAConcept.Services.RiskEvaluator>();

            var app = builder.Build();

            // Assert
            Assert.NotNull(app);
            Assert.NotNull(app.Services.GetService<SURAConcept.Services.RiskEvaluator>());
        }
    }
}
