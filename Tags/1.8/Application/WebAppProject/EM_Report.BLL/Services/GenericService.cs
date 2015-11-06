using EM_Report.Common.Utilities;
using EM_Report.DAL;
using EM_Report.DAL.Infrastructure;
using EM_Report.Domain;
using LinqKit;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Threading;

namespace EM_Report.BLL.Services
{
    public interface I_StatusService : I_Service<Status> { }

    public class StatusService : ServiceBase<Status, StatusDO>, I_StatusService
    {
        public StatusService(I_LoginSession session)
            : base(session)
        {
        }

        protected override IQueryable<Status> GetMapping(IQueryable<StatusDO> query)
        {
            var result = from p in query
                         select new Status()
                         {
                             StatusId = p.StatusId,
                             Name = p.Name,
                             Description = p.Description
                         };
            return result;
        }
    }

    public interface I_Dashboard_OrganisationRole_LevelsServiceService : I_Service<Dashboard_OrganisationRole_Levels> {
        IQueryable<Dashboard_OrganisationRole_Levels> GetPermissionForInternalUser(int GroupIdOrLevelId, int SortValue, string Url); 
    }

    public class Dashboard_OrganisationRole_LevelsService : ServiceBase<Dashboard_OrganisationRole_Levels, Dashboard_OrganisationRole_LevelDO>, I_Dashboard_OrganisationRole_LevelsServiceService
    {
        private I_Repository<DashboardDO> _DashboardRepository;

        public I_Repository<DashboardDO> DashboardRepository
        {
            get { return _DashboardRepository; }
            set { _DashboardRepository = value; }
        }
        private I_Repository<Dashboard_LevelDO> _DashboardLevelRepository;

        public I_Repository<Dashboard_LevelDO> DashboardLevelRepository
        {
            get { return _DashboardLevelRepository; }
            set { _DashboardLevelRepository = value; }
        }
        private I_Repository<Organisation_LevelDO> _OrganisationLevelRepository;

        public I_Repository<Organisation_LevelDO> OrganisationLevelRepository
        {
            get { return _OrganisationLevelRepository; }
            set { _OrganisationLevelRepository = value; }
        }

        private I_Repository<Dashboard_OrganisationRole_LevelDO> _Dashboard_OrganisationRoleRepository;

        public I_Repository<Dashboard_OrganisationRole_LevelDO> Dashboard_OrganisationRoleRepository
        {
            get { return _Dashboard_OrganisationRoleRepository; }
            set { _Dashboard_OrganisationRoleRepository = value; }
        }

        public Dashboard_OrganisationRole_LevelsService(I_LoginSession session)
            : base(session)
        {
            _DashboardRepository = new RepositoryBase<DashboardDO>(((RepositoryBase<Dashboard_OrganisationRole_LevelDO>)Repository).Context);
            _DashboardLevelRepository = new RepositoryBase<Dashboard_LevelDO>(((RepositoryBase<Dashboard_OrganisationRole_LevelDO>)Repository).Context);
            _OrganisationLevelRepository = new RepositoryBase<Organisation_LevelDO>(((RepositoryBase<Dashboard_OrganisationRole_LevelDO>)Repository).Context);
            _Dashboard_OrganisationRoleRepository = new RepositoryBase<Dashboard_OrganisationRole_LevelDO>(((RepositoryBase<Dashboard_OrganisationRole_LevelDO>)Repository).Context);
        }

        public IQueryable<Dashboard_OrganisationRole_Levels> GetPermissionForInternalUser(int LevelId, int SortValue, string Url)
        {
            var DashList = DashboardRepository.GetQueryable();
            var DashLevelList = DashboardLevelRepository.GetQueryable();
            var OrgLevelList = OrganisationLevelRepository.GetQueryable();
            var query = Dashboard_OrganisationRoleRepository.GetQueryable();
            var result = from p in query
                         join s in DashList on p.DashboardId equals s.DashboardId
                         join t in DashLevelList on p.DashboardLevelId equals t.DashboardLevelId
                         join m in OrgLevelList on p.LevelId equals m.LevelId
                         where p.LevelId == LevelId && (t.Sort == SortValue || t.Sort == 1) && s.Url.Contains(Url)
                         select new Dashboard_OrganisationRole_Levels()
                         {
                             DashboardOrganisationlevelId = p.DashboardOrganisationlevelId,
                             DashboardId = p.DashboardId,
                             DashboardLevelId = p.DashboardLevelId,
                             LevelId = p.LevelId,
                             Create_Date = p.Create_Date,
                             Owner = p.Owner,
                             UpdatedBy = p.UpdatedBy
                         };
            return result;
        }

        protected override IQueryable<Dashboard_OrganisationRole_Levels> GetMapping(IQueryable<Dashboard_OrganisationRole_LevelDO> query)
        {
            var DashList = DashboardRepository.GetQueryable();
            var DashLevelList = DashboardLevelRepository.GetQueryable();
            var OrgLevelList = OrganisationLevelRepository.GetQueryable();
            var result = from p in query
                         join s in DashList on p.DashboardId equals s.DashboardId
                         join t in DashLevelList on p.DashboardLevelId equals t.DashboardLevelId
                         join m in OrgLevelList on p.LevelId equals m.LevelId                        
                         select new Dashboard_OrganisationRole_Levels()
                         {
                             DashboardOrganisationlevelId = p.DashboardOrganisationlevelId,
                             DashboardId = p.DashboardId,
                             DashboardLevelId = p.DashboardLevelId,
                             LevelId = p.LevelId,
                             Create_Date = p.Create_Date,
                             Owner = p.Owner,
                             UpdatedBy = p.UpdatedBy
                         };
            return result;
        }        
    }
    
    public interface I_DashboardExternal_GroupsServiceService : I_Service<DashboardExternal_Groups> 
    {
        IQueryable<DashboardExternal_Groups> GetPermissionForExternalUser(int GroupIdOrLevelId, int SortValue, string Url); 
    }    

    public class DashboardExternal_GroupsService : ServiceBase<DashboardExternal_Groups, DashboardExternal_GroupsDO>, I_DashboardExternal_GroupsServiceService
    {
        private I_Repository<DashboardDO> _DashboardRepository;

        public I_Repository<DashboardDO> DashboardRepository
        {
            get { return _DashboardRepository; }
            set { _DashboardRepository = value; }
        }
        private I_Repository<Dashboard_LevelDO> _DashboardLevelRepository;

        public I_Repository<Dashboard_LevelDO> DashboardLevelRepository
        {
            get { return _DashboardLevelRepository; }
            set { _DashboardLevelRepository = value; }
        }

        private I_Repository<External_GroupDO> _ExternalGroupRepository;

        public I_Repository<External_GroupDO> ExternalGroupRepository
        {
            get { return _ExternalGroupRepository; }
            set { _ExternalGroupRepository = value; }
        }

        private I_Repository<DashboardExternal_GroupsDO> _DashboardExternal_Groups;

        public I_Repository<DashboardExternal_GroupsDO> DashboardExternal_Groups
        {
            get { return _DashboardExternal_Groups; }
            set { _DashboardExternal_Groups = value; }
        }

        public DashboardExternal_GroupsService(I_LoginSession session)
            : base(session)
        {
            _DashboardRepository = new RepositoryBase<DashboardDO>(((RepositoryBase<DashboardExternal_GroupsDO>)Repository).Context);
            _DashboardLevelRepository = new RepositoryBase<Dashboard_LevelDO>(((RepositoryBase<DashboardExternal_GroupsDO>)Repository).Context);
            _ExternalGroupRepository = new RepositoryBase<External_GroupDO>(((RepositoryBase<DashboardExternal_GroupsDO>)Repository).Context);
            _DashboardExternal_Groups = new RepositoryBase<DashboardExternal_GroupsDO>(((RepositoryBase<DashboardExternal_GroupsDO>)Repository).Context);
        }

        public IQueryable<DashboardExternal_Groups> GetPermissionForExternalUser(int GroupId, int SortValue, string Url)
        {
            var DashList = DashboardRepository.GetQueryable();
            var DashLevelList = DashboardLevelRepository.GetQueryable();
            var ExtGrp = ExternalGroupRepository.GetQueryable();
            var query = DashboardExternal_Groups.GetQueryable();
            var result = from p in query
                         join s in DashList on p.DashboardId equals s.DashboardId
                         join t in DashLevelList on p.DashboardLevelId equals t.DashboardLevelId
                         join m in ExtGrp on p.External_GroupId equals m.External_GroupId
                         where p.External_GroupId == GroupId && t.Sort == SortValue && s.Url.Contains(Url)
                         select new DashboardExternal_Groups()
                         {
                             DashboardExternal_GroupId = p.DashboardExternal_GroupId,
                             DashboardId = p.DashboardId,
                             DashboardLevelId = p.DashboardLevelId,
                             External_GroupId = p.External_GroupId,
                             Create_Date = p.Create_Date,
                             Owner = p.Owner,
                             UpdatedBy = p.UpdatedBy
                         };
            return result;
        }

        protected override IQueryable<DashboardExternal_Groups> GetMapping(IQueryable<DashboardExternal_GroupsDO> query)
        {            
            var DashList = DashboardRepository.GetQueryable();
            var DashLevelList = DashboardLevelRepository.GetQueryable();
            var ExtGrp = ExternalGroupRepository.GetQueryable();
            var result = from p in query
                         join s in DashList on p.DashboardId equals s.DashboardId
                         join t in DashLevelList on p.DashboardLevelId equals t.DashboardLevelId
                         join m in ExtGrp on p.External_GroupId equals m.External_GroupId                        
                         select new DashboardExternal_Groups()
                         {
                             DashboardExternal_GroupId = p.DashboardExternal_GroupId,
                             DashboardId = p.DashboardId,
                             DashboardLevelId = p.DashboardLevelId,
                             External_GroupId = p.External_GroupId,
                             Create_Date = p.Create_Date,
                             Owner = p.Owner,
                             UpdatedBy = p.UpdatedBy
                         };
            return result;
        }        
    }    

    public interface I_SystemPermissionService : I_Service<System_Permission> { }

    public class SystemPermissionService : ServiceBase<System_Permission, System_PermissionDO>, I_SystemPermissionService
    {
        public SystemPermissionService(I_LoginSession session)
            : base(session)
        {
        }

        protected override IQueryable<System_Permission> GetMapping(IQueryable<System_PermissionDO> query)
        {
            var result = from p in query
                         select new System_Permission()
                         {
                             System_PermissionId = p.System_PermissionId,
                             Name = p.Name,
                             Status = p.Status
                         };
            return result;
        }
    }

    public interface I_PermissionService : I_Service<Permission> { }

    public class PermissionService : ServiceBase<Permission, PermissionDO>, I_PermissionService
    {
        public PermissionService(I_LoginSession session)
            : base(session)
        {
        }

        protected override IQueryable<Permission> GetMapping(IQueryable<PermissionDO> query)
        {
            var result = from p in query
                         select new Permission()
                         {
                             PermissionId = p.PermissionId,
                             Name = p.Name,
                             Status = p.Status,
                             Description = p.Description
                         };
            return result;
        }
    }

    public interface I_DashboardService : I_Service<Dashboard> { }

    public class DashboardService : ServiceBase<Dashboard, DashboardDO>, I_DashboardService
    {
        private I_Repository<StatusDO> _statusRepository;
        private I_Repository<UserDO> _repositoryUser;

        public I_Repository<StatusDO> StatusRepository
        {
            get { return _statusRepository; }
            set { _statusRepository = value; }
        }

        public I_Repository<UserDO> RepositoryUser
        {
            get { return _repositoryUser; }
            set { _repositoryUser = value; }
        }

        public DashboardService(I_LoginSession session)
            : base(session)
        {
            _statusRepository = new RepositoryBase<StatusDO>(((RepositoryBase<DashboardDO>)Repository).Context);
            _repositoryUser = new RepositoryBase<UserDO>(((RepositoryBase<DashboardDO>)Repository).Context);
        }

        protected override IQueryable<Dashboard> GetMapping(IQueryable<DashboardDO> query)
        {
            var statusQuery = StatusRepository.GetQueryable();
            var userQuery = RepositoryUser.GetQueryable();
            var result = from p in query
                         join s in statusQuery on p.Status equals s.StatusId
                         join users in userQuery on p.Owner equals users.UserId into temp
                         from users in temp.DefaultIfEmpty()
                         select new Dashboard()
                         {
                             DashboardId = p.DashboardId,
                             SystemId = p.SystemId,
                             Name = p.Name,
                             Url = p.Url,
                             Description = p.Description,
                             Owner = p.Owner,
                             OwnerName = users != null ? users.UserName : string.Empty,
                             UpdatedBy = p.UpdatedBy,
                             Create_Date = p.Create_Date,
                             StatusName = s.Name
                         };
            return result;
        }

        protected override IQueryable<Dashboard> Filter(string keyword, IQueryable<Dashboard> query)
        {
            if (string.IsNullOrEmpty(keyword))
            {
                return query;
            }
            var predicate = PredicateBuilder.False<Dashboard>();
            predicate = predicate.Or(p => p.Name.Contains(keyword));
            predicate = predicate.Or(p => p.Description.Contains(keyword));
            predicate = predicate.Or(p => p.Url.Contains(keyword));
            return query.Where(predicate);
        }
    }

    public interface I_DashboardLevelService : I_Service<Dashboard_Levels> { }

    public class DashboardLevelService : ServiceBase<Dashboard_Levels, Dashboard_LevelDO>, I_DashboardLevelService
    {
        private I_Repository<StatusDO> _statusRepository;
        private I_Repository<UserDO> _repositoryUser;

        public I_Repository<StatusDO> StatusRepository
        {
            get { return _statusRepository; }
            set { _statusRepository = value; }
        }

        public I_Repository<UserDO> RepositoryUser
        {
            get { return _repositoryUser; }
            set { _repositoryUser = value; }
        }

        public DashboardLevelService(I_LoginSession session)
            : base(session)
        {
            _statusRepository = new RepositoryBase<StatusDO>(((RepositoryBase<Dashboard_LevelDO>)Repository).Context);
            _repositoryUser = new RepositoryBase<UserDO>(((RepositoryBase<Dashboard_LevelDO>)Repository).Context);
        }

        protected override IQueryable<Dashboard_Levels> GetMapping(IQueryable<Dashboard_LevelDO> query)
        {
            var statusQuery = StatusRepository.GetQueryable();
            var userQuery = RepositoryUser.GetQueryable();
            var result = from p in query
                         join s in statusQuery on p.Status equals s.StatusId
                         join users in userQuery on p.Owner equals users.UserId into temp
                         from users in temp.DefaultIfEmpty()
                         select new Dashboard_Levels()
                         {
                             DashboardLevelId = p.DashboardLevelId,
                             Name = p.Name,
                             Sort = p.Sort,
                             Create_Date = p.Create_Date,
                             Owner = p.Owner,
                             UpdatedBy = p.UpdatedBy,
                             StatusName = s.Name,
                             Description = p.Description,
                             OwnerName = users != null ? users.UserName : string.Empty
                         };
            return result;
        }

        protected override IQueryable<Dashboard_Levels> Filter(string keyword, IQueryable<Dashboard_Levels> query)
        {
            if (string.IsNullOrEmpty(keyword))
            {
                return query;
            }
            var predicate = PredicateBuilder.False<Dashboard_Levels>();
            predicate = predicate.Or(p => p.Name.Contains(keyword));
            predicate = predicate.Or(p => p.Description.Contains(keyword));
            return query.Where(predicate);
        }
    }

    public interface I_System_Role_PermissionsService : I_Service<System_Role_Permissions> { }

    public class System_Role_PermissionsService : ServiceBase<System_Role_Permissions, System_Role_PermissionDO>, I_System_Role_PermissionsService
    {
        public System_Role_PermissionsService(I_LoginSession session)
            : base(session)
        {
        }

        protected override IQueryable<System_Role_Permissions> GetMapping(IQueryable<System_Role_PermissionDO> query)
        {
            var result = from q in query
                         select new System_Role_Permissions()
                         {
                             System_RoleId = q.System_RoleId,
                             PermissionId = q.PermissionId,
                             System_PermissionId = q.System_PermissionId,
                             Status = q.Status ?? 0,
                             Create_Date = q.Create_Date ?? DateTime.Now,
                             Owner = q.Owner ?? 0,
                             UpdatedBy = q.UpdatedBy
                         };

            return result;
        }
    }

    public interface I_Dashboard_TimeAccessService : I_Service<Dashboard_TimeAccess> { }

    public class Dashboard_TimeAccessService : ServiceBase<Dashboard_TimeAccess, Dashboard_TimeAccessDO>, I_Dashboard_TimeAccessService
    {
        private I_Repository<StatusDO> _statusRepository;

        public I_Repository<StatusDO> StatusRepository
        {
            get { return _statusRepository; }
            set { _statusRepository = value; }
        }

        public Dashboard_TimeAccessService(I_LoginSession session)
            : base(session)
        {
            _statusRepository = new RepositoryBase<StatusDO>(((RepositoryBase<Dashboard_TimeAccessDO>)Repository).Context);
        }

        protected override IQueryable<Dashboard_TimeAccess> GetMapping(IQueryable<Dashboard_TimeAccessDO> query)
        {
            var statusQuery = StatusRepository.GetQueryable();
            var result = from q in query
                         join s in statusQuery on q.Status equals s.StatusId
                         select new Dashboard_TimeAccess()
                         {
                             Id = q.Id,
                             Url = q.Url,
                             UserId = q.UserId,
                             StartTime = q.StartTime,
                             EndTime = q.EndTime,
                             Status = q.Status ?? 0,
                             StatusName = s.Name,
                             Create_Date = q.Create_Date ?? DateTime.Now,
                             Owner = q.Owner ?? 0,
                             UpdatedBy = q.UpdatedBy != null ? q.UpdatedBy : 0
                         };

            return result;
        }
    }

    public interface I_Dashboard_Traffic_Light_RulesService : I_Service<Dashboard_Traffic_Light_Rule> { }

    public class Dashboard_Traffic_Light_RulesService : ServiceBase<Dashboard_Traffic_Light_Rule, Dashboard_Traffic_Light_RuleDO>, I_Dashboard_Traffic_Light_RulesService
    {
        public Dashboard_Traffic_Light_RulesService(I_LoginSession session)
            : base(session)
        {
            ((RepositoryBase<Dashboard_Traffic_Light_RuleDO>)Repository).TableName = "Dashboard_Traffic_Light_Rules";
        }

        protected override IQueryable<Dashboard_Traffic_Light_Rule> GetMapping(IQueryable<Dashboard_Traffic_Light_RuleDO> query)
        {
            var result = from q in query
                         select new Dashboard_Traffic_Light_Rule()
                         {
                             Id = q.Id,
                             SystemId = q.SystemId,
                             //Unit = q.Unit,
                             //Sub_DashboardType = q.Sub_DashboardType,
                             DashboardType = q.DashboardType,
                             Type = q.Type,
                             Value = q.Value,
                             Sub_Value = q.Sub_Value,
                             Measure = q.Measure != null ? q.Measure : 0,
                             Name = q.Name,
                             Color = q.Color,
                             ImageUrl = q.ImageUrl,
                             FromValue = q.FromValue,
                             ToValue = q.ToValue,
                             Description = q.Description
                         };

            return result;
        }

        protected override IQueryable<Dashboard_Traffic_Light_Rule> Filter(string keyword, IQueryable<Dashboard_Traffic_Light_Rule> query)
        {
            if (string.IsNullOrEmpty(keyword))
            {
                return query;
            }

            var predicate = PredicateBuilder.False<Dashboard_Traffic_Light_Rule>();
            predicate = predicate.Or(p => p.SystemId.ToString().Contains(keyword));
            predicate = predicate.Or(p => p.DashboardType.Contains(keyword));
            predicate = predicate.Or(p => p.Type.Contains(keyword));
            predicate = predicate.Or(p => p.Value.Contains(keyword));
            predicate = predicate.Or(p => p.Sub_Value.Contains(keyword));
            predicate = predicate.Or(p => p.Name.Contains(keyword));
            predicate = predicate.Or(p => p.Description.Contains(keyword));
            predicate = predicate.Or(p => p.FromValue.ToString().Contains(keyword));
            predicate = predicate.Or(p => p.ToValue.ToString().Contains(keyword));
            return query.Where(predicate);
        }
    }

    public interface I_Dashboard_FavoursService : I_Service<Dashboard_Favours> { }

    public class Dashboard_FavourService : ServiceBase<Dashboard_Favours, Dashboard_FavourDO>, I_Dashboard_FavoursService
    {
        public Dashboard_FavourService(I_LoginSession session)
            : base(session)
        {
        }

        protected override IQueryable<Dashboard_Favours> GetMapping(IQueryable<Dashboard_FavourDO> query)
        {
            var result = from q in query
                         select new Dashboard_Favours()
                         {
                             FavourId = q.FavourId,
                             Name = q.Name,
                             UserId = q.UserId,
                             Url = q.Url,
                             Status = q.Status ?? 0,
                             Create_Date = q.Create_Date ?? DateTime.Now,
                             Owner = q.Owner ?? 0,
                             UpdateBy = q.UpdatedBy != null ? q.UpdatedBy : 0,
                             Is_Landing_Page = q.Is_Landing_Page ?? false
                         };
            return result;
        }

        protected override IQueryable<Dashboard_Favours> Filter(string keyword, IQueryable<Dashboard_Favours> query)
        {
            if (string.IsNullOrEmpty(keyword))
            {
                return query;
            }
            var predicate = PredicateBuilder.False<Dashboard_Favours>();
            predicate = predicate.Or(p => p.Name.Contains(keyword));
            predicate = predicate.Or(p => p.Url.Contains(keyword));
            predicate = predicate.Or(p => p.UserId.ToString().Contains(keyword));
            return query.Where(predicate);
        }
    }

    public interface I_Dashboard_Graph_DescriptionService : I_Service<Dashboard_Graph_Description> 
    {
        IQueryable<Dashboard_Graph_Description> GetList(string sort, string searchTerm);
    }

    public class Dashboard_Graph_DescriptionService : ServiceBase<Dashboard_Graph_Description, Dashboard_Graph_DescriptionDO>, I_Dashboard_Graph_DescriptionService
    {
        private I_Repository<SystemDO> _systemRepository;

        public Dashboard_Graph_DescriptionService(I_LoginSession session)
            : base(session)
        {
            ((RepositoryBase<Dashboard_Graph_DescriptionDO>)Repository).TableName = "Dashboard_Graph_Description";
            _systemRepository = new RepositoryBase<SystemDO>(((RepositoryBase<Dashboard_Graph_DescriptionDO>)Repository).Context);
        }

        protected override IQueryable<Dashboard_Graph_Description> GetMapping(IQueryable<Dashboard_Graph_DescriptionDO> query)
        {
            var result = from q in query
                         select new Dashboard_Graph_Description()
                         {
                             DescriptionId = q.DescriptionId,
                             SystemId = q.SystemId,
                             Type = q.Type,
                             Description = q.Description,
                             Status = q.Status ?? 0,
                             Create_Date = q.Create_Date ?? DateTime.Now,
                             Owner = q.Owner ?? 0,
                             UpdatedBy = q.UpdatedBy != null ? q.UpdatedBy : 0
                         };
            return result;
        }

        protected override IQueryable<Dashboard_Graph_Description> Filter(string keyword, IQueryable<Dashboard_Graph_Description> query)
        {
            if (string.IsNullOrEmpty(keyword))
            {
                return query;
            }

            var predicate = PredicateBuilder.False<Dashboard_Graph_Description>();
            predicate = predicate.Or(p => p.SystemId.ToString().Contains(keyword));
            predicate = predicate.Or(p => p.Type.Contains(keyword));
            predicate = predicate.Or(p => p.Description.Contains(keyword));
            return query.Where(predicate);
        }

        public IQueryable<Dashboard_Graph_Description> GetList(string sort, string searchTerm)
        {
            var descriptions = GetAllQueryable(sort, searchTerm);
            var systems = _systemRepository.GetQueryable();

            var result = from d in descriptions
                         join s in systems on d.SystemId equals s.SystemId
                         select new Dashboard_Graph_Description
                         {
                             DescriptionId = d.DescriptionId,
                             SystemId = d.SystemId,
                             Type = d.Type,
                             Description = d.Description,
                             Status = d.Status,
                             Create_Date = d.Create_Date,
                             Owner = d.Owner,
                             UpdatedBy = d.UpdatedBy,
                             //ErrorFields = d.ErrorFields,
                             //IsError = d.IsError,
                             //SystemName = s.Name
                         };

            return result;
        }
    }

    public interface I_Dashboard_ProjectionService : I_Service<Dashboard_Projection> { }

    public class Dashboard_TMF_ProjectionService : ServiceBase<Dashboard_Projection, TMF_AWC_ProjectionDO>, I_Dashboard_ProjectionService
    {
        public Dashboard_TMF_ProjectionService(string systemName)
            : base(null)
        {
            this.Repository = new RepositoryBase<TMF_AWC_ProjectionDO>();
            ((RepositoryBase<TMF_AWC_ProjectionDO>)Repository).TableName = "TMF_AWC_Projections";
        }

        protected override IQueryable<Dashboard_Projection> GetMapping(IQueryable<TMF_AWC_ProjectionDO> query)
        {
            var result = from q in query
                         select new Dashboard_Projection()
                         {
                             Id = q.Id,
                             Unit_Type = q.Unit_Type,
                             Unit_Name = q.Unit_Name,
                             Projection = q.Projection,
                             Time_Id = q.Time_Id,
                             Type = q.Type
                         };
            return result;
        }

        protected override IQueryable<Dashboard_Projection> Filter(string keyword, IQueryable<Dashboard_Projection> query)
        {
            if (string.IsNullOrEmpty(keyword))
            {
                return query;
            }

            var predicate = PredicateBuilder.False<Dashboard_Projection>();
            predicate = predicate.Or(p => p.Unit_Type.Contains(keyword));
            predicate = predicate.Or(p => p.Unit_Name.Contains(keyword));
            predicate = predicate.Or(p => p.Type.Contains(keyword));
            predicate = predicate.Or(p => p.Time_Id.ToString().Contains(keyword));
            predicate = predicate.Or(p => p.Projection.ToString().Contains(keyword));
            return query.Where(predicate);
        }
    }

    public class Dashboard_EML_ProjectionService : ServiceBase<Dashboard_Projection, EML_AWC_ProjectionDO>, I_Dashboard_ProjectionService
    {
        public Dashboard_EML_ProjectionService(string systemName)
            : base(null)
        {
            this.Repository = new RepositoryBase<EML_AWC_ProjectionDO>();
            ((RepositoryBase<EML_AWC_ProjectionDO>)Repository).TableName = "EML_AWC_Projections";
        }

        protected override IQueryable<Dashboard_Projection> GetMapping(IQueryable<EML_AWC_ProjectionDO> query)
        {
            var result = from q in query
                         select new Dashboard_Projection()
                         {
                             Id = q.Id,
                             Unit_Type = q.Unit_Type,
                             Unit_Name = q.Unit_Name,
                             Projection = q.Projection,
                             Time_Id = q.Time_Id,
                             Type = q.Type
                         };
            return result;
        }

        protected override IQueryable<Dashboard_Projection> Filter(string keyword, IQueryable<Dashboard_Projection> query)
        {
            if (string.IsNullOrEmpty(keyword))
            {
                return query;
            }

            var predicate = PredicateBuilder.False<Dashboard_Projection>();
            predicate = predicate.Or(p => p.Unit_Type.Contains(keyword));
            predicate = predicate.Or(p => p.Unit_Name.Contains(keyword));
            predicate = predicate.Or(p => p.Type.Contains(keyword));
            predicate = predicate.Or(p => p.Time_Id.ToString().Contains(keyword));
            predicate = predicate.Or(p => p.Projection.ToString().Contains(keyword));
            return query.Where(predicate);
        }
    }

    public class Dashboard_HEM_ProjectionService : ServiceBase<Dashboard_Projection, HEM_AWC_ProjectionDO>, I_Dashboard_ProjectionService
    {
        public Dashboard_HEM_ProjectionService(string systemName)
            : base(null)
        {
            this.Repository = new RepositoryBase<HEM_AWC_ProjectionDO>();
            ((RepositoryBase<HEM_AWC_ProjectionDO>)Repository).TableName = "HEM_AWC_Projections";
        }

        protected override IQueryable<Dashboard_Projection> GetMapping(IQueryable<HEM_AWC_ProjectionDO> query)
        {
            var result = from q in query
                         select new Dashboard_Projection()
                         {
                             Id = q.Id,
                             Unit_Type = q.Unit_Type,
                             Unit_Name = q.Unit_Name,
                             Projection = q.Projection,
                             Time_Id = q.Time_Id,
                             Type = q.Type
                         };
            return result;
        }

        protected override IQueryable<Dashboard_Projection> Filter(string keyword, IQueryable<Dashboard_Projection> query)
        {
            if (string.IsNullOrEmpty(keyword))
            {
                return query;
            }

            var predicate = PredicateBuilder.False<Dashboard_Projection>();
            predicate = predicate.Or(p => p.Unit_Type.Contains(keyword));
            predicate = predicate.Or(p => p.Unit_Name.Contains(keyword));
            predicate = predicate.Or(p => p.Type.Contains(keyword));
            predicate = predicate.Or(p => p.Time_Id.ToString().Contains(keyword));
            predicate = predicate.Or(p => p.Projection.ToString().Contains(keyword));
            return query.Where(predicate);
        }
    }

    public interface I_Dashboard_Target_BaseService : I_Service<Dashboard_Target_Base> { }

    public class Dashboard_TMF_Target_BaseService : ServiceBase<Dashboard_Target_Base, TMF_RTW_Target_BaseDO>, I_Dashboard_Target_BaseService
    {
        public Dashboard_TMF_Target_BaseService(string systemName)
            : base(null)
        {
            this.Repository = new RepositoryBase<TMF_RTW_Target_BaseDO>();
            ((RepositoryBase<TMF_RTW_Target_BaseDO>)Repository).TableName = "TMF_RTW_Target_Base";
        }

        protected override IQueryable<Dashboard_Target_Base> GetMapping(IQueryable<TMF_RTW_Target_BaseDO> query)
        {
            var result = from q in query
                         select new Dashboard_Target_Base()
                         {
                             Id = q.Id,
                             Type = q.Type,
                             Value = q.Value,
                             Sub_Value = q.Sub_Value,
                             Measure = q.Measure,
                             Target = q.Target,
                             Base = q.Base,
                             Status = q.Status ?? 0,
                             Create_Date = q.Create_Date ?? DateTime.Now,
                             UpdatedBy = q.UpdatedBy != null ? q.UpdatedBy : 0,
                             Remuneration = q.Remuneration
                         };
            return result;
        }

        protected override IQueryable<Dashboard_Target_Base> Filter(string keyword, IQueryable<Dashboard_Target_Base> query)
        {
            if (string.IsNullOrEmpty(keyword))
            {
                return query;
            }

            var predicate = PredicateBuilder.False<Dashboard_Target_Base>();
            predicate = predicate.Or(p => p.Type.Contains(keyword));
            predicate = predicate.Or(p => p.Value.Contains(keyword));
            predicate = predicate.Or(p => p.Sub_Value.Contains(keyword));
            predicate = predicate.Or(p => p.Measure.ToString().Contains(keyword));
            predicate = predicate.Or(p => p.Target.ToString().Contains(keyword));
            predicate = predicate.Or(p => p.Base.ToString().Contains(keyword));
            predicate = predicate.Or(p => p.Remuneration.Contains(keyword));
            return query.Where(predicate);
        }
    }

    public class Dashboard_EML_Target_BaseService : ServiceBase<Dashboard_Target_Base, EML_RTW_Target_BaseDO>, I_Dashboard_Target_BaseService
    {
        public Dashboard_EML_Target_BaseService(string systemName)
            : base(null)
        {
            this.Repository = new RepositoryBase<EML_RTW_Target_BaseDO>();
            ((RepositoryBase<EML_RTW_Target_BaseDO>)Repository).TableName = "EML_RTW_Target_Base";
        }

        protected override IQueryable<Dashboard_Target_Base> GetMapping(IQueryable<EML_RTW_Target_BaseDO> query)
        {
            var result = from q in query
                         select new Dashboard_Target_Base()
                         {
                             Id = q.Id,
                             Type = q.Type,
                             Value = q.Value,
                             Sub_Value = q.Sub_Value,
                             Measure = q.Measure,
                             Target = q.Target,
                             Base = q.Base,
                             Status = q.Status ?? 0,
                             Create_Date = q.Create_Date ?? DateTime.Now,
                             UpdatedBy = q.UpdatedBy != null ? q.UpdatedBy : 0,
                             Remuneration = q.Remuneration
                         };
            return result;
        }

        protected override IQueryable<Dashboard_Target_Base> Filter(string keyword, IQueryable<Dashboard_Target_Base> query)
        {
            if (string.IsNullOrEmpty(keyword))
            {
                return query;
            }

            var predicate = PredicateBuilder.False<Dashboard_Target_Base>();
            predicate = predicate.Or(p => p.Type.Contains(keyword));
            predicate = predicate.Or(p => p.Value.Contains(keyword));
            predicate = predicate.Or(p => p.Sub_Value.Contains(keyword));
            predicate = predicate.Or(p => p.Measure.ToString().Contains(keyword));
            predicate = predicate.Or(p => p.Target.ToString().Contains(keyword));
            predicate = predicate.Or(p => p.Base.ToString().Contains(keyword));
            predicate = predicate.Or(p => p.Remuneration.Contains(keyword));
            return query.Where(predicate);
        }
    }

    public class Dashboard_HEM_Target_BaseService : ServiceBase<Dashboard_Target_Base, HEM_RTW_Target_BaseDO>, I_Dashboard_Target_BaseService
    {
        public Dashboard_HEM_Target_BaseService(string systemName)
            : base(null)
        {
            this.Repository = new RepositoryBase<HEM_RTW_Target_BaseDO>();
            ((RepositoryBase<HEM_RTW_Target_BaseDO>)Repository).TableName = "HEM_RTW_Target_Base";
        }

        protected override IQueryable<Dashboard_Target_Base> GetMapping(IQueryable<HEM_RTW_Target_BaseDO> query)
        {
            var result = from q in query
                         select new Dashboard_Target_Base()
                         {
                             Id = q.Id,
                             Type = q.Type,
                             Value = q.Value,
                             Sub_Value = q.Sub_Value,
                             Measure = q.Measure,
                             Target = q.Target,
                             Base = q.Base,
                             Status = q.Status ?? 0,
                             Create_Date = q.Create_Date ?? DateTime.Now,
                             UpdatedBy = q.UpdatedBy != null ? q.UpdatedBy : 0,
                             Remuneration = q.Remuneration
                         };
            return result;
        }

        protected override IQueryable<Dashboard_Target_Base> Filter(string keyword, IQueryable<Dashboard_Target_Base> query)
        {
            if (string.IsNullOrEmpty(keyword))
            {
                return query;
            }

            var predicate = PredicateBuilder.False<Dashboard_Target_Base>();
            predicate = predicate.Or(p => p.Type.Contains(keyword));
            predicate = predicate.Or(p => p.Value.Contains(keyword));
            predicate = predicate.Or(p => p.Sub_Value.Contains(keyword));
            predicate = predicate.Or(p => p.Measure.ToString().Contains(keyword));
            predicate = predicate.Or(p => p.Target.ToString().Contains(keyword));
            predicate = predicate.Or(p => p.Base.ToString().Contains(keyword));
            predicate = predicate.Or(p => p.Remuneration.Contains(keyword));
            return query.Where(predicate);
        }
    }

    public interface I_Report_Organisation_LevelsService : I_Service<Report_Organisation_Levels> { }

    public class Report_Organisation_LevelsService : ServiceBase<Report_Organisation_Levels, Report_Organisation_LevelDO>, I_Report_Organisation_LevelsService
    {
        public Report_Organisation_LevelsService(I_LoginSession session)
            : base(session)
        {
        }

        protected override IQueryable<Report_Organisation_Levels> GetMapping(IQueryable<Report_Organisation_LevelDO> query)
        {
            var result = from p in query
                         select new Report_Organisation_Levels()
                         {
                             ReportId = p.ReportId,
                             LevelId = p.LevelId,
                             Create_Date = p.Create_Date,
                             Owner = p.Owner,
                             UpdatedBy = p.UpdatedBy
                         };
            return result;
        }
    }

    public interface I_CONTROLService : I_Service<CONTROL> { }

    public class CONTROLService : ServiceBase<CONTROL, CONTROLDO>, I_CONTROLService
    {
        public CONTROLService(I_LoginSession session)
            : base(session)
        {
        }

        protected override IQueryable<CONTROL> GetMapping(IQueryable<CONTROLDO> query)
        {
            var result = from p in query
                         select new CONTROL()
                         {
                             Type = p.TYPE,
                             Item = p.ITEM,
                             Value = p.VALUE,
                             Text_Value = p.TEXT_VALUE
                         };            
            return result;
        }       
    }

    

    /// <summary>
    /// Control Date Cut off
    /// </summary>     

    #region PORTFOLIO

    public interface I_WOWPortfolioService
    {
        string GetMaxRptDate();
        IEnumerable<string> GetCliamLiabilityIndicators(string systemName);
    }

    public class WOWPortfolioService : ServiceBase<string, WOW_PortfolioDO>, I_WOWPortfolioService
    {
        private I_Repository<Dashboard_Claim_Liability_IndicatorDO> _claimLiabilityIndicator;

        public I_Repository<Dashboard_Claim_Liability_IndicatorDO> ClaimLiabilityIndicator
        {
            get { return _claimLiabilityIndicator; }
            set { _claimLiabilityIndicator = value; }
        }

        public WOWPortfolioService(I_LoginSession session)
            : base(session)
        {
            _claimLiabilityIndicator = new RepositoryBase<Dashboard_Claim_Liability_IndicatorDO>(((RepositoryBase<WOW_PortfolioDO>)Repository).Context);
        }
        public string GetMaxRptDate()
        {
            var all = Repository.GetQueryable();            
            var result = (from p in all
                          where p.Reporting_Date == all.Max(r => r.Reporting_Date)
                          select p.Reporting_Date).Distinct().OrderBy(t => t).FirstOrDefault();           
            return result.ToString("dd/MM/yyyy");
        }

        public IEnumerable<string> GetCliamLiabilityIndicators(string systemName)
        {
            var all = ClaimLiabilityIndicator.GetQueryable();
            var result = (from p in all
                          where p.System == systemName
                          select p.Description).ToList();

            return result;
        }
    }

    public interface I_TMFPortfolioService
    {
        IEnumerable<string> GetSystemGroups();

        IEnumerable<string> GetSystemAgencies();

        IEnumerable<string> GetTeams(string group);

        IEnumerable<string> GetSubCategories(string group);

        IEnumerable<string> GetClaimOfficers(string team);

        IEnumerable<string> GetCliamLiabilityIndicators(string systemName);

        string GetMaxRptDate();
    }

    public class TMFPortfolioService : ServiceBase<string, TMF_PortfolioDO>, I_TMFPortfolioService
    {
        private I_Repository<TMF_Agencies_Sub_CategoryDO> _agenciesSubCategoryRepository;
        private I_Repository<Dashboard_Claim_Liability_IndicatorDO> _claimLiabilityIndicator;

        public I_Repository<Dashboard_Claim_Liability_IndicatorDO> ClaimLiabilityIndicator
        {
            get { return _claimLiabilityIndicator; }
            set { _claimLiabilityIndicator = value; }
        }

        public I_Repository<TMF_Agencies_Sub_CategoryDO> AgenciesSubCategoryRepository
        {
            get { return _agenciesSubCategoryRepository; }
            set { _agenciesSubCategoryRepository = value; }
        }

        public TMFPortfolioService(I_LoginSession session)
            : base(session)
        {
            _agenciesSubCategoryRepository = new RepositoryBase<TMF_Agencies_Sub_CategoryDO>(((RepositoryBase<TMF_PortfolioDO>)Repository).Context);
            _claimLiabilityIndicator = new RepositoryBase<Dashboard_Claim_Liability_IndicatorDO>(((RepositoryBase<TMF_PortfolioDO>)Repository).Context);
        }

        public IEnumerable<string> GetSystemGroups()
        {
            var storeParams = new Dictionary<string, object>();
            storeParams.Add("System", "TMF");

            var data = Repository.ExecuteDataStoreProcedure("usp_GetGroups", storeParams);
            var result = new List<string>();
            foreach(DataRow row in data.Rows)
            {
                var group = row["Group"].ToString();
                result.Add(group);
            }

            return result;
        }

        public IEnumerable<string> GetSystemAgencies()
        {
            var all = Repository.GetQueryable();
            var result = (from p in all
                          join s in AgenciesSubCategoryRepository.GetQueryable() 
                          on p.Policy_No equals s.POLICY_NO
                          where s.AgencyName != "" && p.Claim_Closed_Flag != "Y" && p.Reporting_Date == all.Max(r => r.Reporting_Date)
                          select s.AgencyName.Trim()).Distinct().OrderBy(a => a).ToList();

            return result;
        }

        public IEnumerable<string> GetTeams(string group)
        {
            var all = Repository.GetQueryable();
            var result = new List<string>();

            if (group.Equals("All", StringComparison.OrdinalIgnoreCase))
            {
                result = (from p in all
                          where p.Team != "" && p.Claim_Closed_Flag != "Y" && p.Reporting_Date == all.Max(r => r.Reporting_Date)
                          select p.Team.Trim()).Distinct().OrderBy(t => t).ToList();
            }
            else
            {
                var storeParams = new Dictionary<string, object>();
                storeParams.Add("System", "TMF");
                storeParams.Add("Group", group);

                var data = Repository.ExecuteDataStoreProcedure("usp_GetTeamsByGroup", storeParams);
                foreach (DataRow row in data.Rows)
                {
                    var team = row["Team"].ToString();
                    result.Add(team);
                }
            }

            return result;
        }

        public IEnumerable<string> GetSubCategories(string agency)
        {
            var all = Repository.GetQueryable();
            var result = new List<string>();

            if (agency.Equals("All", StringComparison.OrdinalIgnoreCase))
            {
                result = (from p in all
                          join a in AgenciesSubCategoryRepository.GetQueryable()
                          on p.Policy_No equals a.POLICY_NO
                          where a.Sub_Category != "" && p.Claim_Closed_Flag != "Y" && p.Reporting_Date == all.Max(r => r.Reporting_Date)
                          select a.Sub_Category.Trim()).Distinct().OrderBy(s => s).ToList();
            }
            else
            {
                result = (from p in all
                          join a in AgenciesSubCategoryRepository.GetQueryable()
                          on p.Policy_No equals a.POLICY_NO
                          where a.AgencyName.Equals(agency) && a.Sub_Category != "" && p.Claim_Closed_Flag != "Y" && p.Reporting_Date == all.Max(r => r.Reporting_Date)
                          select a.Sub_Category.Trim()).Distinct().OrderBy(s => s).ToList();
            }

            return result;
        }

        public IEnumerable<string> GetClaimOfficers(string team)
        {
            var all = Repository.GetQueryable();
            var result = new List<string>();

            if (team.Equals("All", StringComparison.OrdinalIgnoreCase))
            {
                result = (from p in all
                          where p.Claims_Officer_Name != "" && p.Claim_Closed_Flag != "Y" && p.Reporting_Date == all.Max(r => r.Reporting_Date)
                          select p.Claims_Officer_Name.Trim()).Distinct().OrderBy(c => c).ToList();
            }
            else
            {
                result = (from p in all
                          where p.Team.Equals(team) && p.Claims_Officer_Name != "" && p.Claim_Closed_Flag != "Y" && p.Reporting_Date == all.Max(r => r.Reporting_Date)
                          select p.Claims_Officer_Name.Trim()).Distinct().OrderBy(c => c).ToList();
            }

            return result;
        }

        public IEnumerable<string> GetCliamLiabilityIndicators(string systemName)
        {
            var all = ClaimLiabilityIndicator.GetQueryable();
            var result = (from p in all
                          where p.System == systemName
                          select p.Description).ToList();

            return result;
        }

        public string GetMaxRptDate()
        {
            var all = Repository.GetQueryable();
            var result = (from p in all
                          where p.Reporting_Date == all.Max(r => r.Reporting_Date)
                          select p.Reporting_Date).Distinct().OrderBy(t => t).First();

            return result.ToString("dd/MM/yyyy");
        }
    }

    public interface I_HEMPortfolioService
    {
        IEnumerable<string> GetSystemGroups();

        IEnumerable<string> GetSystemPortfolios();

        IEnumerable<string> GetSystemAccountManagers();

        IEnumerable<string> GetTeams(string group);

        IEnumerable<string> GetEMPL_SizesByAccountManager(string accountManager);

        IEnumerable<string> GetEMPL_SizesByPortfolio(string portfolio);

        IEnumerable<string> GetCliamLiabilityIndicators(string systemName);

        string GetMaxRptDate();

    }

    public class HEMPortfolioService : ServiceBase<string, HEM_PortfolioDO>, I_HEMPortfolioService
    {
        private I_Repository<Dashboard_Claim_Liability_IndicatorDO> _claimLiabilityIndicator;

        public I_Repository<Dashboard_Claim_Liability_IndicatorDO> ClaimLiabilityIndicator
        {
            get { return _claimLiabilityIndicator; }
            set { _claimLiabilityIndicator = value; }
        }

        public HEMPortfolioService(I_LoginSession session)
            : base(session)
        {
            _claimLiabilityIndicator = new RepositoryBase<Dashboard_Claim_Liability_IndicatorDO>(((RepositoryBase<HEM_PortfolioDO>)Repository).Context);
        }

        public IEnumerable<string> GetSystemGroups()
        {
            var storeParams = new Dictionary<string, object>();
            storeParams.Add("System", "HEM");

            var data = Repository.ExecuteDataStoreProcedure("usp_GetGroups", storeParams);
            var result = new List<string>();
            foreach (DataRow row in data.Rows)
            {
                var group = row["Group"].ToString();
                result.Add(group);
            }

            return result;
        }

        public IEnumerable<string> GetSystemPortfolios()
        {
            var all = Repository.GetQueryable();
            var result = (from p in all
                          where p.Portfolio != "" && p.Claim_Closed_Flag != "Y" && p.Reporting_Date == all.Max(r => r.Reporting_Date)
                          select p.Portfolio.Trim()).Distinct().OrderBy(p => p).ToList();

            return result;
        }

        public IEnumerable<string> GetSystemAccountManagers()
        {
            var all = Repository.GetQueryable();
            var result = (from p in all
                          where p.Account_Manager != "" && p.Claim_Closed_Flag != "Y" && p.Reporting_Date == all.Max(r => r.Reporting_Date)
                          select p.Account_Manager.Trim()).Distinct().OrderBy(a => a).ToList();

            return result;
        }

        public IEnumerable<string> GetTeams(string group)
        {
            var all = Repository.GetQueryable();
            var result = new List<string>();

            if (group.Equals("All", StringComparison.OrdinalIgnoreCase))
            {
                result = (from p in all
                          where p.Team != "" && p.Claim_Closed_Flag != "Y" && p.Reporting_Date == all.Max(r => r.Reporting_Date)
                          select p.Team.Trim()).Distinct().OrderBy(t => t).ToList();
            }
            else
            {
                var storeParams = new Dictionary<string, object>();
                storeParams.Add("System", "HEM");
                storeParams.Add("Group", group);

                var data = Repository.ExecuteDataStoreProcedure("usp_GetTeamsByGroup", storeParams);
                foreach (DataRow row in data.Rows)
                {
                    var team = row["Team"].ToString();
                    result.Add(team);
                }
            }

            return result;
        }

        public IEnumerable<string> GetEMPL_SizesByAccountManager(string accountManager)
        {
            var all = Repository.GetQueryable();
            var result = new List<string>();

            if (accountManager.Equals("All", StringComparison.OrdinalIgnoreCase))
            {
                result = (from p in all
                          where p.EMPL_SIZE != "" && p.Claim_Closed_Flag != "Y" && p.Reporting_Date == all.Max(r => r.Reporting_Date)
                          select p.EMPL_SIZE.Trim()).Distinct().OrderBy(e => e).ToList();
            }
            else
            {
                result = (from p in all
                          where p.Account_Manager.Equals(accountManager) && p.EMPL_SIZE != "" && p.Claim_Closed_Flag != "Y" && p.Reporting_Date == all.Max(r => r.Reporting_Date)
                          select p.EMPL_SIZE.Trim()).Distinct().OrderBy(e => e).ToList();
            }

            return result;
        }

        public IEnumerable<string> GetEMPL_SizesByPortfolio(string portfolio)
        {
            var all = Repository.GetQueryable();
            var result = new List<string>();

            if (portfolio.Equals("All", StringComparison.OrdinalIgnoreCase))
            {
                result = (from p in all
                          where p.EMPL_SIZE != "" && p.Claim_Closed_Flag != "Y" && p.Reporting_Date == all.Max(r => r.Reporting_Date)
                          select p.EMPL_SIZE.Trim()).Distinct().OrderBy(e => e).ToList();
            }
            else
            {
                result = (from p in all
                          where p.Portfolio.Equals(portfolio) && p.EMPL_SIZE != "" && p.Claim_Closed_Flag != "Y" && p.Reporting_Date == all.Max(r => r.Reporting_Date)
                          select p.EMPL_SIZE.Trim()).Distinct().OrderBy(e => e).ToList();
            }

            return result;
        }

        public IEnumerable<string> GetCliamLiabilityIndicators(string systemName)
        {
            var all = ClaimLiabilityIndicator.GetQueryable();
            var result = (from p in all
                          where p.System == systemName
                          select p.Description).ToList();

            return result;
        }

        public string GetMaxRptDate()
        {
            var all = Repository.GetQueryable();
            var result = (from p in all
                          where p.Reporting_Date == all.Max(r => r.Reporting_Date)
                          select p.Reporting_Date).Distinct().OrderBy(t => t).First();

            return result.ToString("dd/MM/yyyy");
        }
    }

    public interface I_EMLPortfolioService
    {
        IEnumerable<string> GetSystemGroups();

        IEnumerable<string> GetSystemAccountManagers();

        IEnumerable<string> GetSystemEMPL_Sizes();

        IEnumerable<string> GetTeams(string group);

        IEnumerable<string> GetEMPL_SizesByAccountManager(string accountManager);

        IEnumerable<string> GetCliamLiabilityIndicators(string systemName);

        string GetMaxRptDate();
    }

    public class EMLPortfolioService : ServiceBase<string, EML_PortfolioDO>, I_EMLPortfolioService
    {
        private I_Repository<Dashboard_Claim_Liability_IndicatorDO> _claimLiabilityIndicator;

        public I_Repository<Dashboard_Claim_Liability_IndicatorDO> ClaimLiabilityIndicator
        {
            get { return _claimLiabilityIndicator; }
            set { _claimLiabilityIndicator = value; }
        }

        public EMLPortfolioService(I_LoginSession session)
            : base(session)
        {
            _claimLiabilityIndicator = new RepositoryBase<Dashboard_Claim_Liability_IndicatorDO>(((RepositoryBase<EML_PortfolioDO>)Repository).Context);
        }

        public IEnumerable<string> GetSystemGroups()
        {
            var storeParams = new Dictionary<string, object>();
            storeParams.Add("System", "EML");

            var data = Repository.ExecuteDataStoreProcedure("usp_GetGroups", storeParams);
            var result = new List<string>();
            foreach (DataRow row in data.Rows)
            {
                var group = row["Group"].ToString();
                result.Add(group);
            }

            return result;
        }

        public IEnumerable<string> GetSystemAccountManagers()
        {
            var all = Repository.GetQueryable();
            var result = (from p in all
                          where p.Account_Manager != "" && p.Claim_Closed_Flag != "Y" && p.Reporting_Date == all.Max(r => r.Reporting_Date)
                          select p.Account_Manager.Trim()).Distinct().OrderBy(a => a).ToList();

            return result;
        }

        public IEnumerable<string> GetSystemEMPL_Sizes()
        {
            var all = Repository.GetQueryable();
            var result = (from p in all
                          where p.EMPL_SIZE != "" && p.Claim_Closed_Flag != "Y" && p.Reporting_Date == all.Max(r => r.Reporting_Date)
                          select p.EMPL_SIZE.Trim()).Distinct().OrderBy(e => e).ToList();

            return result;
        }

        public IEnumerable<string> GetTeams(string group)
        {
            var all = Repository.GetQueryable();
            var result = new List<string>();

            if (group.Equals("All", StringComparison.OrdinalIgnoreCase))
            {
                result = (from p in all
                          where p.Team != "" && p.Claim_Closed_Flag != "Y" && p.Reporting_Date == all.Max(r => r.Reporting_Date)
                          select p.Team.Trim()).Distinct().OrderBy(t => t).ToList();
            }
            else
            {
                var storeParams = new Dictionary<string, object>();
                storeParams.Add("System", "EML");
                storeParams.Add("Group", group);

                var data = Repository.ExecuteDataStoreProcedure("usp_GetTeamsByGroup", storeParams);
                foreach (DataRow row in data.Rows)
                {
                    var team = row["Team"].ToString();
                    result.Add(team);
                }
            }

            return result;
        }

        public IEnumerable<string> GetEMPL_SizesByAccountManager(string accountManager)
        {
            var all = Repository.GetQueryable();
            var result = new List<string>();

            if (accountManager.Equals("All", StringComparison.OrdinalIgnoreCase))
            {
                result = (from p in all
                          where p.EMPL_SIZE != "" && p.Claim_Closed_Flag != "Y" && p.Reporting_Date == all.Max(r => r.Reporting_Date)
                          select p.EMPL_SIZE.Trim()).Distinct().OrderBy(e => e).ToList();
            }
            else
            {
                result = (from p in all
                          where p.Account_Manager.Equals(accountManager) && p.EMPL_SIZE != "" && p.Claim_Closed_Flag != "Y" && p.Reporting_Date == all.Max(r => r.Reporting_Date)
                          select p.EMPL_SIZE.Trim()).Distinct().OrderBy(e => e).ToList();
            }

            return result;
        }

        public IEnumerable<string> GetCliamLiabilityIndicators(string systemName)
        {
            var all = ClaimLiabilityIndicator.GetQueryable();
            var result = (from p in all
                          where p.System == systemName
                          select p.Description).ToList();

            return result;
        }

        public string GetMaxRptDate()
        {
            var all = Repository.GetQueryable();
            var result = (from p in all
                          where p.Reporting_Date == all.Max(r => r.Reporting_Date)
                          select p.Reporting_Date).Distinct().OrderBy(t => t).First();

            return result.ToString("dd/MM/yyyy");
        }
    }

    #endregion PORTFOLIO

    #region Import data feature

    public interface IProjectionService : I_Service<Dashboard_Projection> { }

    public class TMFProjectionService : ServiceBase<Dashboard_Projection, TMF_AWC_ProjectionDO>, IProjectionService
    {
        public TMFProjectionService(string systemName)
            : base(null)
        {
        }
    }

    public class EMLProjectionService : ServiceBase<Dashboard_Projection, EML_AWC_ProjectionDO>, IProjectionService
    {
        public EMLProjectionService(string systemName)
            : base(null)
        {
        }
    }

    public class HEMProjectionService : ServiceBase<Dashboard_Projection, HEM_AWC_ProjectionDO>, IProjectionService
    {
        public HEMProjectionService(string systemName)
            : base(null)
        {
        }
    }

    #endregion Import data feature

    #region Agencies_Sub_Category
    public interface I_Agencies_Sub_CategoryService : I_Service<Agencies_Sub_Category> { }

    public class Agencies_Sub_CategoryService : ServiceBase<Agencies_Sub_Category, TMF_Agencies_Sub_CategoryDO>, I_Agencies_Sub_CategoryService
    {
        public Agencies_Sub_CategoryService(I_LoginSession session)
            : base(session)
        {
        }

        protected override IQueryable<Agencies_Sub_Category> GetMapping(IQueryable<TMF_Agencies_Sub_CategoryDO> query)
        {
            var result = from p in query
                         select new Agencies_Sub_Category()
                         {
                             Id = p.Id,
                             AgencyId = p.AgencyId,
                             AgencyName = p.AgencyName,
                             Sub_Category = p.Sub_Category,
                             POLICY_NO = p.POLICY_NO,
                             Group = p.Group
                         };
            return result;
        }
    }
    #endregion Agencies_Sub_Category
}