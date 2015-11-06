using System;
using System.Linq;
using EM_Report.BLL.Commons;
using EM_Report.DAL;
using EM_Report.DAL.Infrastructure;
using EM_Report.Models;

namespace EM_Report.BLL.Services
{
    public interface I_OrganisationRole_Levels_AuditService : I_Service<OrganisationRole_Levels_AuditModel>
    {
        
    }

    public class OrganisationRole_Levels_AuditService : ServiceBase<OrganisationRole_Levels_AuditModel, OrganisationRole_Levels_Audit>, I_OrganisationRole_Levels_AuditService
    {
        private I_Repository<User> _userRepository;
        private I_Repository<Organisation_Role> _organisationRepository;
        private I_Repository<Organisation_Level> _organisationRoleRepository;

        public I_Repository<Organisation_Level> OrganisationRoleRepository
        {
            get { return _organisationRoleRepository; }
            set { _organisationRoleRepository = value; }
        }
        
        public I_Repository<Organisation_Role> OrganisationRepository
        {
            get { return _organisationRepository; }
            set { _organisationRepository = value; }
        }

        public I_Repository<User> UserRepository
        {
            get { return _userRepository; }
            set { _userRepository = value; }
        }

        public OrganisationRole_Levels_AuditService(I_LoginSession session)
            : base(session)
        {
            _userRepository = new RepositoryBase<User>(((RepositoryBase<OrganisationRole_Levels_Audit>)Repository).Context);
            _organisationRepository = new RepositoryBase<Organisation_Role>(((RepositoryBase<OrganisationRole_Levels_Audit>)Repository).Context);
            _organisationRoleRepository = new RepositoryBase<Organisation_Level>(((RepositoryBase<OrganisationRole_Levels_Audit>)Repository).Context);
        }        
       

        protected override OrganisationRole_Levels_AuditModel MappingToModel(OrganisationRole_Levels_Audit tbl)
        {
            return tbl == null ? null : new OrganisationRole_Levels_AuditModel()
            {
                Id = tbl.Id,
                Name = tbl.Name,
                LevelId = tbl.LevelId,
                Sort = tbl.Sort ?? 0,                             
                Action_Date = tbl.Action_Date,
                Action_Type = tbl.Action_Type,
                Action_Owner = tbl.Action_Owner
            };
        }

        protected override OrganisationRole_Levels_Audit MappingToDAL(OrganisationRole_Levels_AuditModel tbl)
        {
            return tbl == null ? null : new OrganisationRole_Levels_Audit()
            {
                Id = tbl.Id,
                Name = tbl.Name,
                LevelId = tbl.LevelId,
                Sort = tbl.Sort,                              
                Action_Date = tbl.Action_Date,
                Action_Type = tbl.Action_Type,
                Action_Owner = tbl.Action_Owner
            };
        }

        protected override IQueryable<OrganisationRole_Levels_AuditModel> Filter(string keyword, string startdate, string enddate, IQueryable<OrganisationRole_Levels_AuditModel> query)
        {
            var predicate = PredicateBuilder.False<OrganisationRole_Levels_AuditModel>();            
            predicate = predicate.Or(p => p.Description.Contains(keyword));
            predicate = predicate.Or(p => p.Action_Type.Contains(keyword));
            predicate = predicate.Or(p => p.OwnerName.Contains(keyword));
            //predicate = predicate.Or(p => p.LevelName.Contains(keyword));
            predicate = predicate.Or(p => p.ParentLevelName.Contains(keyword));
            //predicate = predicate.Or(p => p.Organisation_RoleName.Contains(keyword));

            if (!string.IsNullOrEmpty(startdate) && startdate != "mm/dd/yyyy")
            {
                predicate = predicate.And(p => p.Action_Date >= DateTime.ParseExact(startdate + " 00:00:00.000", "MM/dd/yyyy HH:mm:ss.fff", new System.Globalization.CultureInfo("en-US", true)));
            }
            if (!string.IsNullOrEmpty(enddate) && enddate != "mm/dd/yyyy")
            {
                predicate = predicate.And(p => p.Action_Date <= DateTime.ParseExact(enddate + " 23:59:59.000", "MM/dd/yyyy HH:mm:ss.fff", new System.Globalization.CultureInfo("en-US", true)));
            }
            return query.Where(predicate);
        }

        protected override IQueryable<OrganisationRole_Levels_AuditModel> GetMapping(IQueryable<OrganisationRole_Levels_Audit> query)
        {
            //var userQuery = UserRepository.GetQueryable();
            //var organisationQuery = OrganisationRepository.GetQueryable();
            //var parentLevelQuery = OrganisationRoleRepository.GetQueryable();
            //var result = from q in query
            //             join o in organisationQuery on q.Organisation_RoleId equals o.Organisation_RoleId into temp1
            //             from o in temp1.DefaultIfEmpty()
            //             join u in userQuery on q.Action_Owner equals u.UserId into temp2
            //             from u in temp2.DefaultIfEmpty()
            //             join p in parentLevelQuery on q.Sort equals p.LevelId into temp3
            //             from p in temp3.DefaultIfEmpty()
            //             join l in parentLevelQuery on q.LevelId equals l.LevelId into temp4
            //             from l in temp4.DefaultIfEmpty()   
            //             select new OrganisationRole_Levels_AuditModel()
            //             {
            //                 Id = q.Id,
            //                 Name = q.Name,
            //                // Organisation_RoleId = q.Organisation_RoleId,
            //                 LevelId = q.LevelId, 
            //                // LevelName = l.Name,
            //                 Sort = q.Sort ?? 0,
            //                 Description = q.Description,                             
            //                 OwnerName = u != null ? u.UserName : string.Empty,
            //                 //Organisation_RoleName = o.Name,
            //                 ParentLevelName = p.Name,
            //                 Action_Date = q.Action_Date,
            //                 Action_Type = q.Action_Type,
            //                 Action_Owner = q.Action_Owner
            //             };          

            //return result;
            return null;
        }
    }    
}