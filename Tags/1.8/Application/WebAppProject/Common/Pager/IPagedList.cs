namespace EM_Report.Common.Pager
{
    public interface IPagedList
    {
        int CurrentPageIndex { get; set; }
        int PageSize { get; set; }
        int TotalItemCount { get; set; }
        int StartRecordIndex { get; }
        int EndRecordIndex { get; }
    }
}
