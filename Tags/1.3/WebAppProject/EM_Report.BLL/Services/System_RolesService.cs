using System;
using System.Collections.Generic;
using System.Linq;
using EM_Report.BLL.Commons;
using EM_Report.DAL;
using EM_Report.Models;

namespace EM_Report.BLL.Services
{    
    public interface I_System_RolesService : I_Service<System_RolesModel>
    {
        bool Save(long system_roleid,string name,string description,string systemroles);        
    }

    public class System_RolesService : ServiceBase<System_RolesModel, System_Role>, I_System_RolesService
    {
        public System_RolesService(I_LoginSession session)
            : base(session)
        {
        }
        
        protected override System_RolesModel MappingToModel(System_Role tbTeamSystem_Roles)
        {
            return tbTeamSystem_Roles == null ? null : new System_RolesModel()
            {
                System_RoleId = tbTeamSystem_Roles.System_RoleId,
                Name = tbTeamSystem_Roles.Name,
                Description = tbTeamSystem_Roles.Description                                 
            };
        }

        protected override System_Role MappingToDAL(System_RolesModel tbTeamSystem_Roles)
        {
            return tbTeamSystem_Roles == null ? null : new System_Role()
            {
                System_RoleId = tbTeamSystem_Roles.System_RoleId,
                Name = tbTeamSystem_Roles.Name,
                Description = tbTeamSystem_Roles.Description
            };
        }

        protected override IQueryable<System_RolesModel> GetMapping(IQueryable<System_Role> query)
        {            
            var result = from q in query                         
                        select new System_RolesModel()
                        {
                            System_RoleId = q.System_RoleId,
                            Name = q.Name,
                            Description = q.Description
                        };
            return result;
        }

        public bool Save(long system_roleid, string name, string description, string systemroles)
        {
            try
            {
                Dictionary<string, object> dicParams = new Dictionary<string, object>();
                dicParams.Add("@System_RoleId", system_roleid);
                dicParams.Add("@Name", name);
                dicParams.Add("@Description", description);
                dicParams.Add("@SystemRoles", systemroles);
                dicParams.Add("@UpdatedBy", Session.intUserId);
                if (Repository.ExecuteScalarStoreProcedure("sp_SaveSystemRoles", dicParams).ToString() == "1")
                    return true;
                else
                    return false;
            }
            catch (Exception) { return false; }
        }

        protected override IQueryable<System_RolesModel> Filter(string keyword, IQueryable<System_RolesModel> query)
        {
            if (string.IsNullOrEmpty(keyword))
            {
                return query;
            }
            var predicate = PredicateBuilder.False<System_RolesModel>();
            predicate = predicate.Or(p => p.Name.Contains(keyword));
            predicate = predicate.Or(p => p.Description.Contains(keyword));
            return query.Where(predicate);
        }        
    }    
}