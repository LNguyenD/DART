using EM_Report.ActionServiceReference;
using EM_Report.Domain;
using EM_Report.Domain.Resources;
using EM_Report.Helpers;
using System;
using System.Linq;

namespace EM_Report.Repositories
{
    /// <summary>
    /// Report Repository interface.
    /// Note: does not derive from IRepository.
    /// </summary>
    public interface IReportPermissionRepository
    {
        ReportPermission Get(object rptId);

        void Delete(int rptId);

        void AddReportExternalAccess(ReportPermission model, Report_External_Access externalGroup);

        void RemoveReportExternalAccess(ReportPermission model, Report_External_Access externalGroup);

        void AddOrganisationRole(ReportPermission model, Report_Organisation_Levels organisationRole);

        void RemoveOrganisationRole(ReportPermission model, Report_Organisation_Levels organisationRole);

        bool HaveReportPermission(bool isSystemUser, string reportUrl, int levelId, string systemName);
    }

    public class ReportPermissionRepository : RepositoryBase, IReportPermissionRepository
    {
        /// <summary>
        /// Gets an individual user by id.
        /// </summary>
        /// <param name="rptId"></param>
        /// <returns></returns>
        public ReportPermission Get(object rptId)
        {
            var request = new ReportPermissionRequest().Prepare();
            request.LoadOptions = new[] { Resource.Get_Option_Single };
            request.ReportId = int.Parse(rptId.ToString());
            request.Criteria = new Criteria();
            var response = Client.GetReportPermissions(request);
            Correlate(request, response);

            return response.ReportPermission;
        }

        /// <summary>
        /// Deletes an existing report permission.
        /// </summary>
        /// <param name="rptId"></param>
        public void Delete(int rptId)
        {
            var request = new ReportPermissionRequest().Prepare();

            request.Action = Resource.Action_Delete;
            request.ReportId = rptId;

            var response = Client.SetReportPermissions(request);
            Correlate(request, response);

            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }

        public void AddReportExternalAccess(ReportPermission model, Domain.Report_External_Access externalGroup)
        {
            var request = new ReportPermissionRequest().Prepare();
            request.Action = "AddReportExternalAccess";
            request.ReportExternalAccess = externalGroup;
            request.ReportPermission = model;

            var response = Client.SetReportPermissions(request);
            Correlate(request, response);

            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }

        public void RemoveReportExternalAccess(ReportPermission model, Report_External_Access externalGroup)
        {
            var request = new ReportPermissionRequest().Prepare();
            request.Action = "RemoveReportExternalAccess";
            request.ReportExternalAccess = externalGroup;
            request.ReportPermission = model;

            var response = Client.SetReportPermissions(request);
            Correlate(request, response);

            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }

        public void AddOrganisationRole(ReportPermission model, Report_Organisation_Levels organisationRole)
        {
            var request = new ReportPermissionRequest().Prepare();
            request.Action = "AddOrganisationRole";
            request.ReportOrganisationLevel = organisationRole;
            request.ReportPermission = model;

            var response = Client.SetReportPermissions(request);
            Correlate(request, response);

            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }

        public void RemoveOrganisationRole(ReportPermission model, Report_Organisation_Levels organisationRole)
        {
            var request = new ReportPermissionRequest().Prepare();
            request.Action = "RemoveOrganisationRole";
            request.ReportOrganisationLevel = organisationRole;
            request.ReportPermission = model;

            var response = Client.SetReportPermissions(request);
            Correlate(request, response);

            if (response.Acknowledge == AcknowledgeType.Failure)
                throw new ApplicationException(response.Message);
        }

        public bool HaveReportPermission(bool isSystemUser, string reportUrl, int levelId, string systemName)
        {
            if (isSystemUser)
                return true;

            var request = new Report_Organisation_LevelsRequest().Prepare();
            request.LoadOptions = new string[] { Resource.Get_Option_Single };
            request.Url = reportUrl;
            request.LevelId = levelId; // default level id

            // correct level id follow the requested system
            if (systemName != string.Empty)
            {
                var system = Base.LoginSession.lstSystems.SingleOrDefault(s => s.Name.ToLower() == systemName.ToLower());
                if (system != null && system.LevelId > 0)
                    request.LevelId = system.LevelId; // pass only level id for system that user has requested
            }

            var response = Client.GetReport_Organisation_Levels(request);

            Base.TotalItemCount = response.TotalItemCount;

            Correlate(request, response);

            return response.Report_Organisation_Level != null ? true : false;
        }
    }
}