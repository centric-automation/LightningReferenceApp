using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using Microsoft.ApplicationInsights.Channel;
using Microsoft.ApplicationInsights.Extensibility;

namespace referenceApp.Api.Telemetry
{
    public class ApplicationNameTelemetryInitializer : ITelemetryInitializer
    {
        private readonly string versionString;

        public ApplicationNameTelemetryInitializer()
        {
            versionString = Assembly.GetExecutingAssembly().GetName().Version.ToString();
        }

        public ApplicationNameTelemetryInitializer(Version version)
        {
            versionString = version.ToString();
        }

        public void Initialize(ITelemetry telemetry)
        {

            telemetry.Context.Cloud.RoleName = "referenceApp.Api";
            telemetry.Context.Component.Version = versionString;
        }
    }
}
