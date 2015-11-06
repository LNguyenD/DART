using System;
using System.Collections.Generic;
using System.Linq;
using EM_Report.Common.Utilities;
using EM_Report.DAL;
using EM_Report.Domain;
using EM_Report.DAL.Infrastructure;

namespace EM_Report.BLL.Services
{    
    public interface I_System_RolesService : I_Service<System_Roles>
    {
        bool Save(long system_roleid,string name,string description,string systemroles,int updatedBy);        
    }

    public class System_RolesService : ServiceBase<System_Roles, System_RoleDO>, I_System_RolesService
    {
        public System_RolesService(I_LoginSession session)
            : base(session)
        {
        }

        public System_RolesService(I_Repository<System_RoleDO> repo, I_LoginSession session)
            : base(repo, session)
        {
        } 

        protected override IQueryable<System_Roles> GetMapping(IQueryable<System_RoleDO> query)
        {            
            var result = from q in query                         
                        select new System_Roles()
                        {
                            System_RoleId = q.System_RoleId,
                            Name = q.Name,
                            Description = q.Description
                        };
            return result;
        }

        public bool Save(long system_roleid, string name, string description, string systemroles,int updatedby)
        {
            try
            {
                Dictionary<string, object> dicParams = new Dictionary<string, object>();
                dicParams.Add("@System_RoleId", system_roleid);
                dicParams.Add("@Name", name);
                dicParams.Add("@Description", description);
                dicParams.Add("@SystemRoles", systemroles);
                dicParams.Add("@UpdatedBy", updatedby);
                if (Repository.ExecuteScalarStoreProcedure("sp_SaveSystemRoles", dicParams).ToString() == "1")
                    return true;
                else
                    return false;
            }
            catch (Exception) { return false; }
        }

        protected override IQueryable<System_Roles> Filter(string keyword, IQueryable<System_Roles> query)
        {
            if (string.IsNullOrEmpty(keyword))
            {
                return query;
            }
            var predicate = PredicateBuilder.False<System_Roles>();
            predicate = predicate.Or(p => p.Name.Contains(keyword));
            predicate = predicate.Or(p => p.Description.Contains(keyword));
            return query.Where(predicate);
        }        
    }    
}