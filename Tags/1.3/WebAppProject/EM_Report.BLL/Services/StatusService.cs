using EM_Report.BLL.Commons;
using EM_Report.DAL;
using EM_Report.Models;

namespace EM_Report.BLL.Services
{
    public interface I_StatusService : I_Service<StatusModel>
    {
    }

    public class StatusService : ServiceBase<StatusModel, Status>, I_StatusService
    {
        #region private member variables
        #endregion

        #region private properties
        #endregion

        #region private methods
        protected override StatusModel MappingToModel(Status tbStatus)
        {
            return tbStatus == null ? null : new StatusModel()
            {
                StatusId = tbStatus.StatusId,
                Name = tbStatus.Name,
                Description = tbStatus.Description
            };
        }

        protected override Status MappingToDAL(StatusModel model)
        {
            return model == null ? null : new EM_Report.DAL.Status()
            {
                StatusId = model.StatusId,
                Name = model.Name,
                Description = model.Description
            };
        }
        #endregion

        #region constructors
        public StatusService(I_LoginSession session) : base(session) { }
        #endregion

        #region public properties
        #endregion

        #region public methods
        #endregion
    }
}