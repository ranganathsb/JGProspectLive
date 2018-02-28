namespace JG_Prospect.Common
{
    public class Enums
    {
        public enum Aptitude_ExamType
        {
            DotNet = 2
        }
    }

    public enum TouchPointSource
    {
        EditUserPage = 1,
        ITDashboard = 2,
        InterviewPopup = 3,
        TouchPointLogPage = 4,
        ViewSalesUser = 5,
        ViewApplicantUser = 6,
        CreateSalesUser = 7,
        TaskGenerator = 8
    }

    public enum ChatSource
    {
        EditUserPage = 1,
        ITDashboard = 2,
        InterviewPopup = 3,
        TouchPointLogPage = 4,
        ViewSalesUser = 5,
        ViewApplicantUser = 6,
        CreateSalesUser = 7,
        TaskGenerator = 8,
        TaskChat = 9,
        UserChat = 10
    }

    public enum ChatUserStatus
    {
        Active = 1,
        Idle = 2
    }
}
