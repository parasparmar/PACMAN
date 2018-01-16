using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data.Sql;
using System.Reflection;

public partial class PacmanDiscussion : System.Web.UI.Page
{
    DataTable dtEmp;
    Helper my;
    private string strSQL { get; set; }
    private int MyEmpID { get; set; }
    private int ForEmpID { get; set; }
    private int MyRepMgr { get; set; }
    private int PacmanCycle { get; set; }
    private int RStage { get; set; }
    private int IsRepMgr { get; set; }
    private string MySkillset { get; set; }
    private DateTime StartDate { get; set; }
    private DateTime EndDate { get; set; }
    private decimal SLRating { get; set; }
    private decimal OptimizationRating { get; set; }
    private decimal EIRating { get; set; }
    private decimal AbsenteeismRating { get; set; }
    private decimal BTPRating { get; set; }
    public string lblPacmanCycle { get; set; }
    public DataTable DtOfAccountsIHandle { get; set; }
    private int IEXMgmt { get; set; }
    private int AnalyticProject { get; set; }
    private int AnalyticTimeline { get; set; }
    private int Accuracy { get; set; }
    private int AnalyticCoaching { get; set; }
    private decimal SchedulingAccuracy { get; set; }
    private decimal ForecastingAccuracy { get; set; }
    private decimal HeadcountAccuracy { get; set; }
    private decimal FinalRating { get; set; }

    protected void Page_Load(object sender, EventArgs e)
    {
        my = new Helper();

        try
        {
            dtEmp = (DataTable)Session["dtEmp"];
            if (dtEmp.Rows.Count <= 0)
            {
                Response.Redirect("index.aspx", false);
            }
            else
            {
                // In Production Use the below
                MyEmpID = Convert.ToInt32(dtEmp.Rows[0]["Employee_Id"].ToString());
                //MyRepMgr = Convert.ToInt32(dtEmp.Rows[0]["RepMgrCode"].ToString());
            }
        }
        catch (Exception Ex)
        {
            Console.WriteLine(Ex.Message.ToString());
            Response.Redirect(ViewState["PreviousPageUrl"] != null ? ViewState["PreviousPageUrl"].ToString() : "index.aspx", false);
        }
        Literal title = (Literal)PageExtensionMethods.FindControlRecursive(Master, "ltlPageTitle");
        title.Text = "PACMAN Discussion";

        btnSubmitPacman.Enabled = false;


        if (!IsPostBack)
        {
            fillddlReviewPeriod();
            fillddlStage();
            fillddlReportee();
            ddlStage_DataBound(sender, e);
            if (RStage == 3 || RStage == 4 || RStage == 5)
            {
                btnYesDiscussed.Enabled = false;
                btnNotDiscussed.Enabled = false;
            }
            else if (RStage == 2)
            {
                btnYesDiscussed.Enabled = false;
                btnNotDiscussed.Enabled = false;
                btnSubmitPacman.Enabled = true;
            }
            else
            {
                btnYesDiscussed.Enabled = true;
                btnNotDiscussed.Enabled = true;
            }
            if (IsRepMgr == 0)
            {
                btnYesDiscussed.Enabled = false;
                btnNotDiscussed.Enabled = false;
            }

            DtOfAccountsIHandle = getDtOfAccountsIHandle();
            showRelevantMetricPanels(MyEmpID);
        }
    }

    private DataTable getDtOfAccountsIHandle()
    {
        string strSQL = "WFMPMS.GetAllAccountsIHandle";
        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.Parameters.AddWithValue("@Employee_ID", MyEmpID);
        StartDate = DateTime.Today.Date;
        //cmd.Parameters.AddWithValue("@StartDate", StartDate);

        DataTable dt = my.GetDataTableViaProcedure(ref cmd);
        //dt.DefaultView.RowFilter = "InBO=1";
        //gvAllMyAccounts.DataSource = dt;
        //gvAllMyAccounts.DataBind();

        return dt;


    }

    private void showRelevantMetricPanels(int ForEmpID)
    {
        string strSQL = "SELECT Distinct B.id, B.Metrics FROM [CWFM_Umang].[WFMPMS].[tblEmp2Account] A  ";
        strSQL += " inner join [WFMPMS].[tblDsgn2KPIWtg] B on B.SkillsetId = A.SkillsetId  ";
        strSQL += " where EmpCode =  " + ForEmpID + " and [Active] = 1 and '" + StartDate + "' between A.FromDate and A.ToDate ";
        strSQL += " order by B.id, B.Metrics ";

        DataTable dt = my.GetData(strSQL);
        string myPanelName = string.Empty;

        foreach (DataRow d in dt.Rows)
        {
            myPanelName = "pnl_" + d["Metrics"].ToString().Replace("&", "").Replace(" ", "_");
            Control c = Page.FindControlRecursive(myPanelName);
            if (c != null)
            {
                Panel thePanel = c as Panel;
                thePanel.Visible = true;
            }
        }
    }

    private void fillddlReviewPeriod()
    {
        string strSQL = "WFMPMS.[GetPacmanCycleforPacmanDiscussion]";
        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.Parameters.AddWithValue("@EmpCode", MyEmpID);
        DataTable dt = my.GetDataTableViaProcedure(ref cmd);
        ddlReviewPeriod.DataSource = dt;
        ddlReviewPeriod.DataTextField = "TextDescription";
        ddlReviewPeriod.DataValueField = "Id";
        ddlReviewPeriod.DataBind();
        ddlReviewPeriod.SelectedIndex = 0;
    }

    private void fillddlStage()
    {
        string strSQL = "[WFMPMS].[GetReviewStage]";
        SqlCommand cmd = new SqlCommand(strSQL);
        DataTable dt1 = my.GetDataTableViaProcedure(ref cmd);
        ddlStage.DataSource = dt1;
        ddlStage.DataTextField = "Stage";
        ddlStage.DataValueField = "Id";
        ddlStage.DataBind();
    }

    protected void ddlStage_SelectedIndexChanged(object sender, EventArgs e)
    {
        fillddlReportee();

        ddlStage_DataBound(sender, e);
        if (RStage == 3 || RStage == 4 || RStage == 5)
        {
            btnYesDiscussed.Enabled = false;
            btnNotDiscussed.Enabled = false;
        }
        else if (RStage == 2)
        {
            btnYesDiscussed.Enabled = false;
            btnNotDiscussed.Enabled = false;
            btnSubmitPacman.Enabled = true;
        }
        else
        {
            btnYesDiscussed.Enabled = true;
            btnNotDiscussed.Enabled = true;
        }
    }

    protected void ddlReviewPeriod_SelectedIndexChanged(object sender, EventArgs e)
    {
        PacmanCycle = Convert.ToInt32(ddlReviewPeriod.SelectedValue);
        string strSQL = "SELECT [FromDate],[ToDate] FROM [CWFM_Umang].[WFMPMS].[tblPacmanCycle] where [ID] =" + PacmanCycle;
        DataTable dt = my.GetData(strSQL);
        StartDate = Convert.ToDateTime(dt.Rows[0]["FromDate"].ToString());
        EndDate = Convert.ToDateTime(dt.Rows[0]["ToDate"].ToString());
        fillddlStage();
        fillddlReportee();
        ltlEmloyeeBanner.Text = " Performance Management Cycle : " + ddlReviewPeriod.SelectedItem.Text.ToString();
        if (ddlReportee.Items.Count > 0)
        {
            ltlEmloyeeBanner.Text = ddlReportee.SelectedItem.Text.ToString() + ltlEmloyeeBanner.Text;
        }

    }

    private void fillddlReportee()
    {
        PacmanCycle = Convert.ToInt32(ddlReviewPeriod.SelectedValue);
        int stageNo = Convert.ToInt32(ddlStage.SelectedValue);

        string strSQL = "[WFMPMS].[fillEmployeePacmanDiscussion]";
        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.Parameters.AddWithValue("@EmpCode", MyEmpID);
        cmd.Parameters.AddWithValue("@stageNo", stageNo);
        cmd.Parameters.AddWithValue("@PacmanCycle", PacmanCycle);
        DataTable dt2 = my.GetDataTableViaProcedure(ref cmd);
        ddlReportee.DataSource = dt2;
        ddlReportee.DataTextField = "Name";
        ddlReportee.DataValueField = "EmpCode";
        ddlReportee.DataBind();
        fillRelevantMetricsInPanels(MyEmpID);
        getFinalRating(MyEmpID);
    }

    private void fillRelevantMetricsInPanels(int ForEmpID)
    {
        string strSQL = "SELECT Distinct B.id, B.Metrics FROM [CWFM_Umang].[WFMPMS].[tblEmp2Account] A  ";
        strSQL += " inner join [WFMPMS].[tblDsgn2KPIWtg] B on B.SkillsetId = A.SkillsetId  ";
        strSQL += " where EmpCode =  " + ForEmpID + " and [Active] = 1 and '" + StartDate + "' between A.FromDate and A.ToDate ";
        strSQL += " order by B.id, B.Metrics ";

        DataTable dt = my.GetData(strSQL);
        string myPanelName = string.Empty;

        foreach (DataRow d in dt.Rows)
        {
            myPanelName = "pnl_" + d["Metrics"].ToString().Replace("&", "").Replace(" ", "_");
            Control c = Page.FindControlRecursive(myPanelName);
            if (c != null)
            {
                Panel thePanel = c as Panel;
                thePanel.Visible = true;
                Type thisType = this.GetType();
                MethodInfo theMethod = thisType.GetMethod("fill" + myPanelName);
                theMethod.Invoke(this, new object[] { MyEmpID });


                //fillpnl_Absenteeism --Done
                //fillpnl_KPI --Done
                //fillpnl_BTP --Done
                //fillpnl_Accuracy  --Done -- Analytics KPI
                //fillpnl_Attrition --NA -- Manager KPI
                //fillpnl_Coaching_Feedback-- Analytics KPI
                //fillpnl_Escalations --Done
                //fillpnl_Forecasting_Accuracy --Empty Method
                //fillpnl_Headcount_Accuracy --Empty Method
                //fillpnl_IEX_Management --Done
                //fillpnl_On_Time_Delivery -- Analytics KPI
                //fillpnl_Projects --Done
                //fillpnl_Real_Time_Optimization --Done
                //fillpnl_Revenue_Cost_optimization -- Manager KPI
                //fillpnl_Scheduling_Accuracy
            }
        }
    }
    protected void btnYesDiscussed_Click(object sender, EventArgs e)
    {
        btnSubmitPacman.Enabled = true;
        btnYesDiscussed.Enabled = false;
        btnNotDiscussed.Enabled = false;

        SqlConnection con = new SqlConnection(my.getConnectionString());
        con.Open();

        String strSQL = "[WFMPMS].[InsertPacmanStage]";
        SqlCommand cmd = new SqlCommand(strSQL, con);
        cmd.CommandType = CommandType.StoredProcedure;

        MyEmpID = Convert.ToInt32(dtEmp.Rows[0]["Employee_Id"].ToString());
        int reportee = Convert.ToInt32(ddlReportee.SelectedItem.Value.ToString());
        int PreviousStage = Convert.ToInt32(ddlStage.SelectedItem.Value.ToString());
        int Stage = 2;
        PacmanCycle = Convert.ToInt32(ddlReviewPeriod.SelectedItem.Value.ToString());
        cmd.Parameters.AddWithValue("@EmpCode", reportee);
        cmd.Parameters.AddWithValue("@Stage", Stage);
        cmd.Parameters.AddWithValue("@PacmanCycle", PacmanCycle);
        cmd.Parameters.AddWithValue("@ActionBy", MyEmpID);
        cmd.Parameters.AddWithValue("@PreviousStage", PreviousStage);

        cmd.Connection = con;
        cmd.ExecuteNonQuery();
        con.Close();

        //fillddlReportee();
    }
    protected void ddlStage_DataBound(object sender, EventArgs e)
    {
        RStage = Convert.ToInt32(ddlStage.SelectedItem.Value.ToString());
        strSQL = "[WFMPMS].[GetIsRepMgr]";
        using (SqlConnection cn = new SqlConnection(my.getConnectionString()))
        {
            cn.Open();
            using (SqlCommand cmd = new SqlCommand(strSQL, cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@EmpCode", MyEmpID);
                IsRepMgr = Convert.ToInt32(cmd.ExecuteScalar());
            }
        }
    }
    protected void btnSubmitPacman_Click(object sender, EventArgs e)
    {
        btnYesDiscussed.Enabled = false;
        btnNotDiscussed.Enabled = false;
        btnSubmitPacman.Enabled = false;

        SqlConnection con = new SqlConnection(my.getConnectionString());
        con.Open();

        String strSQL = "[WFMPMS].[InsertPacmanStage]";
        SqlCommand cmd = new SqlCommand(strSQL, con);
        cmd.CommandType = CommandType.StoredProcedure;

        MyEmpID = Convert.ToInt32(dtEmp.Rows[0]["Employee_Id"].ToString());
        int reportee = Convert.ToInt32(ddlReportee.SelectedItem.Value.ToString());
        int PreviousStage = Convert.ToInt32(ddlStage.SelectedItem.Value.ToString());
        int Stage = 3;
        PacmanCycle = Convert.ToInt32(ddlReviewPeriod.SelectedItem.Value.ToString());
        cmd.Parameters.AddWithValue("@EmpCode", reportee);
        cmd.Parameters.AddWithValue("@Stage", Stage);
        cmd.Parameters.AddWithValue("@PacmanCycle", PacmanCycle);
        cmd.Parameters.AddWithValue("@ActionBy", MyEmpID);
        cmd.Parameters.AddWithValue("@PreviousStage", PreviousStage);

        cmd.Connection = con;
        cmd.ExecuteNonQuery();
        con.Close();

        fillddlReportee();
    }

    private void clearIEXMgmtScorefields()
    {
        ddlIEXMgmtScore.ClearSelection();
        txtIEXMgmtComments.Text = string.Empty;
    }

    protected void btnIEXMgmtScoreSubmit_Click(object sender, EventArgs e)
    {
        SqlConnection con = new SqlConnection(my.getConnectionString());
        con.Open();

        String strSQL = "[WFMPMS].[InsertIEXManagementScore]";
        SqlCommand cmd = new SqlCommand(strSQL, con);
        cmd.CommandType = CommandType.StoredProcedure;
        PacmanCycle = Convert.ToInt32(ddlReviewPeriod.SelectedItem.Value.ToString());
        int reportee = Convert.ToInt32(ddlReportee.SelectedItem.Value.ToString());
        int score = Convert.ToInt32(ddlIEXMgmtScore.SelectedItem.Value.ToString());
        string comments = txtIEXMgmtComments.Text.ToString();

        cmd.Parameters.AddWithValue("@PacmanCycle", PacmanCycle);
        cmd.Parameters.AddWithValue("@EmpCode", reportee);
        cmd.Parameters.AddWithValue("@Score", score);
        cmd.Parameters.AddWithValue("@Comments", comments);
        cmd.Parameters.AddWithValue("@ActionedBy", MyEmpID);
        cmd.Connection = con;
        cmd.ExecuteNonQuery();
        con.Close();
        ltlIEX_Management.Text = "IEX Management &nbsp= &nbsp" + "<div class=\"pull-right header\">" + score + "</div>";
        clearIEXMgmtScorefields();
    }

    protected void ddlReportee_SelectedIndexChanged(object sender, EventArgs e)
    {
        ForEmpID = Convert.ToInt32(ddlReportee.SelectedItem.Value.ToString());
        if (ddlReviewPeriod.SelectedValue == "17")
        {

            fillRelevantMetricsInPanels(ForEmpID);
        }
    }

    protected void btnAnalyticProjectScoreSubmit_Click(object sender, EventArgs e)
    {
        SqlConnection con = new SqlConnection(my.getConnectionString());
        con.Open();

        String strSQL = "[WFMPMS].[InsertAnalyticsProjectsScore]";
        SqlCommand cmd = new SqlCommand(strSQL, con);
        cmd.CommandType = CommandType.StoredProcedure;
        PacmanCycle = Convert.ToInt32(ddlReviewPeriod.SelectedItem.Value.ToString());
        int reportee = Convert.ToInt32(ddlReportee.SelectedItem.Value.ToString());
        int scoreProjects = Convert.ToInt32(ddlAnalyticProject.SelectedItem.Value.ToString());
        string commentsProjects = txtAnalyticProject.Text.ToString();

        cmd.Parameters.AddWithValue("@PacmanCycle", PacmanCycle);
        cmd.Parameters.AddWithValue("@EmpCode", reportee);
        cmd.Parameters.AddWithValue("@Score", scoreProjects);
        cmd.Parameters.AddWithValue("@Comments", commentsProjects);
        cmd.Parameters.AddWithValue("@ActionedBy", MyEmpID);
        cmd.Connection = con;
        cmd.ExecuteNonQuery();
        con.Close();
        ltlProject.Text = "Projects &nbsp= &nbsp" + "<div class=\"pull-right header\">" + scoreProjects + "</div>";
        clearAnalyticProjectScorefields();

    }

    private void clearAnalyticProjectScorefields()
    {
        ddlAnalyticProject.ClearSelection();
        txtAnalyticProject.Text = string.Empty;
    }

    protected void btnCoachingScoreSubmit_Click(object sender, EventArgs e)
    {
        SqlConnection con = new SqlConnection(my.getConnectionString());
        con.Open();

        String strSQL = "[WFMPMS].[InsertAnalyticsCoachingScore]";
        SqlCommand cmd = new SqlCommand(strSQL, con);
        cmd.CommandType = CommandType.StoredProcedure;
        PacmanCycle = Convert.ToInt32(ddlReviewPeriod.SelectedItem.Value.ToString());
        int reportee = Convert.ToInt32(ddlReportee.SelectedItem.Value.ToString());
        int scoreCoaching = Convert.ToInt32(ddlCoaching.SelectedItem.Value.ToString());
        string commentsCoaching = txtCoachingComments.Text.ToString();

        cmd.Parameters.AddWithValue("@PacmanCycle", PacmanCycle);
        cmd.Parameters.AddWithValue("@EmpCode", reportee);
        cmd.Parameters.AddWithValue("@Score", scoreCoaching);
        cmd.Parameters.AddWithValue("@Comments", commentsCoaching);
        cmd.Parameters.AddWithValue("@ActionedBy", MyEmpID);
        cmd.Connection = con;
        cmd.ExecuteNonQuery();
        con.Close();
        ltlCoachingFeedback.Text = "Coaching & Feedback &nbsp= &nbsp" + "<div class=\"pull-right header\">" + scoreCoaching + "</div>";
        clearAnalyticCoachingScorefields();
    }

    private void clearAnalyticCoachingScorefields()
    {
        ddlCoaching.ClearSelection();
        txtCoachingComments.Text = string.Empty;
    }

    private void fillltlfinalScore(int ForEmpID)
    {
        int FinalScore = 0;
        strSQL = "[WFMPMS].[getPacmanFinalScore]";
        using (SqlConnection cn = new SqlConnection(my.getConnectionString()))
        {
            cn.Open();
            using (SqlCommand cmd = new SqlCommand(strSQL, cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@EmpCode", ForEmpID);
                cmd.Parameters.AddWithValue("@PacmanCycle", PacmanCycle);
                SqlDataReader sdr = cmd.ExecuteReader();
                while (sdr.Read())
                {
                    if (sdr.HasRows)
                    {
                        FinalScore = Convert.ToInt32(sdr.GetValue(0));
                        ltlfinalScore.Text = FinalScore.ToString();
                    }
                    else
                    { ltlfinalScore.Text = "Pacman discussion not completed"; }
                }

            }
        }
    }

    protected void gv_PreRender(object sender, EventArgs e)
    {
        GridView gv = (GridView)sender;
        if (gv.Rows.Count > 0)
        {
            gv.UseAccessibleHeader = true;
            gv.HeaderRow.TableSection = TableRowSection.TableHeader;
            gv.HeaderStyle.BorderStyle = BorderStyle.None;
            gv.BorderStyle = BorderStyle.None;
            gv.BorderWidth = Unit.Pixel(1);
        }
    }

    private void getFinalRating(int ForEmpID)
    {
        string strSQL = "SELECT Distinct B.id, B.Metrics, B.Weight FROM [CWFM_Umang].[WFMPMS].[tblEmp2Account] A  ";
        strSQL += " inner join [WFMPMS].[tblDsgn2KPIWtg] B on B.SkillsetId = A.SkillsetId  ";
        strSQL += " where EmpCode =  " + ForEmpID + " and [Active] = 1 and '" + StartDate + "' between A.FromDate and A.ToDate ";
        strSQL += " order by B.id, B.Metrics, B.Weight ";

        FinalRating = 0;
        DataTable dtWeights = my.GetData(strSQL);
        foreach (DataRow dr in dtWeights.Rows)
        {
            Decimal KPIWt = Convert.ToDecimal(dr["Weight"].ToString());
            string KPIname = dr["Metrics"].ToString().Replace("&", "").Replace(" ", "_");
            Literal ltl = (Literal)Page.FindControlRecursive("ltl_" + KPIname);
            if (ltl != null)
            {
                Decimal KPIScore = Convert.ToDecimal(ltl.Text);
                FinalRating = FinalRating + (KPIScore * KPIWt);
            }
        }
        ltlfinalScore.Text = FinalRating.ToString();

    }

    #region Analytics KPIs
    public void fillltlAnalyticCoaching(int ForEmpID)
    {
        AnalyticCoaching = 0;
        strSQL = "[WFMPMS].[getAnalyticCoachingScore]";
        using (SqlConnection cn = new SqlConnection(my.getConnectionString()))
        {
            cn.Open();
            using (SqlCommand cmd = new SqlCommand(strSQL, cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@EmpCode", ForEmpID);
                cmd.Parameters.AddWithValue("@PacmanCycle", PacmanCycle);
                SqlDataReader sdr = cmd.ExecuteReader();
                while (sdr.Read())
                {
                    if (sdr.HasRows)
                    {
                        AnalyticCoaching = Convert.ToInt32(sdr.GetValue(0));
                    }
                }
                ltlCoachingFeedback.Text = "Coaching & Feedback &nbsp= &nbsp" + "<div class=\"pull-right header\">" + AnalyticCoaching + "</div>";
            }

        }
    }
    public void fillltlAnalyticTimeline(int ForEmpID)
    {
        AnalyticTimeline = 0;
        strSQL = "[WFMPMS].[GetAnalyticTimelineScore]";
        using (SqlConnection cn = new SqlConnection(my.getConnectionString()))
        {
            cn.Open();
            using (SqlCommand cmd = new SqlCommand(strSQL, cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@EmpCode", ForEmpID);
                cmd.Parameters.AddWithValue("@PacmanCycle", PacmanCycle);
                SqlDataReader sdr = cmd.ExecuteReader();
                while (sdr.Read())
                {
                    if (sdr.HasRows)
                    {
                        string val = sdr.GetValue(0).ToString();
                        //AnalyticTimeline = Convert.ToInt32(sdr.GetValue(0));
                        if (val != null)
                            ltlOntimeDelivery.Text = "On Time Delivery &nbsp= &nbsp" + "<div class=\"pull-right header\">" + AnalyticTimeline + "</div>";
                        else
                        {
                            int noVal = 0;
                            ltlOntimeDelivery.Text = noVal.ToString();
                        }

                    }
                    //else {
                    //    int noVal = 0;
                    //    ltlOntimeDelivery.Text = noVal.ToString();
                    //}
                }

            }

        }
    }
    public void fillpnl_Absenteeism(int ForEmpID)
    {


        AbsenteeismRating = 0;
        strSQL = "[WFMPMS].[GetSelfAttendanceScore]";
        using (SqlConnection cn = new SqlConnection(my.getConnectionString()))
        {
            cn.Open();
            using (SqlCommand cmd = new SqlCommand(strSQL, cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@EmpCode", ForEmpID);
                cmd.Parameters.AddWithValue("@PacmanCycle", PacmanCycle);
                SqlDataReader sdr = cmd.ExecuteReader();
                while (sdr.Read())
                {
                    if (sdr.HasRows)
                    {
                        AbsenteeismRating = Convert.ToInt32(sdr.GetValue(0));
                    }
                }
                ltlAbsenteeism.Text = "Self-Attendance &nbsp= &nbsp";
                ltl_Absenteeism.Text = AbsenteeismRating.ToString();
            }

        }
    }
    public void fillpnl_Accuracy(int ForEmpID)
    {
        Accuracy = 0;
        strSQL = "[WFMPMS].[GetAnalyticAccuracyScore]";
        using (SqlConnection cn = new SqlConnection(my.getConnectionString()))
        {
            cn.Open();
            using (SqlCommand cmd = new SqlCommand(strSQL, cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@EmpCode", ForEmpID);
                cmd.Parameters.AddWithValue("@PacmanCycle", PacmanCycle);
                SqlDataReader sdr = cmd.ExecuteReader();
                while (sdr.Read())
                {
                    if (sdr.HasRows)
                    {
                        Accuracy = Convert.ToInt32(sdr.GetValue(0));
                        ltlAccuracy.Text = "Accuracy &nbsp= &nbsp" + "<div class=\"pull-right header\">" + Accuracy + "</div>";
                    }
                    else
                    {
                        int noVal = 0;
                        ltlAccuracy.Text = noVal.ToString();
                    }
                }
                //ltlAccuracy.Text = "Accuracy &nbsp= &nbsp" + "<div class=\"pull-right header\">" + Accuracy + "</div>";
            }

        }
    }
    public void fillpnl_Projects(int ForEmpID)
    {
        AnalyticProject = 0;
        strSQL = "[WFMPMS].[getAnalyticProjectScore]";
        using (SqlConnection cn = new SqlConnection(my.getConnectionString()))
        {
            cn.Open();
            using (SqlCommand cmd = new SqlCommand(strSQL, cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@EmpCode", ForEmpID);
                cmd.Parameters.AddWithValue("@PacmanCycle", PacmanCycle);
                SqlDataReader sdr = cmd.ExecuteReader();
                while (sdr.Read())
                {
                    if (sdr.HasRows)
                    {
                        AnalyticProject = Convert.ToInt32(sdr.GetValue(0));
                    }
                }
                ltlAnalyticProject.Text = "Projects &nbsp= &nbsp" + "<div class=\"pull-right header\">" + AnalyticProject + "</div>";
            }

        }
    }
    #endregion Analytics KPIs
    #region Manager
    public void fillpnl_Attrition(int ForEmpID)
    {
        // Not in Scope - not defined.
    }
    public void fillpnl_Revenue_Cost_optimization(int ForEmpID)
    {
        // Not in Scope - not defined. 
    }
    #endregion
    #region Planning
    public void fillpnl_BTP(int ForEmpID)
    {
        List<string> myAccounts = new List<string>();
        if (DtOfAccountsIHandle == null)
        {
            DtOfAccountsIHandle = getDtOfAccountsIHandle();
        }
        DataTable dt = new DataTable();
        DataTable scratchTable = new DataTable();
        foreach (DataRow d in DtOfAccountsIHandle.Rows)
        {
            strSQL = "WFMPMS.getBTPForAccount";
            SqlCommand cmd = new SqlCommand(strSQL);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@AccountId", d["PrimaryClientID"].ToString());
            cmd.Parameters.AddWithValue("@Month", StartDate);
            scratchTable = my.GetDataTableViaProcedure(ref cmd);
            if (scratchTable != null && scratchTable.Rows.Count > 0)
            {
                dt.Merge(scratchTable);
            }
        }
        GridView gvBTP = new GridView();
        gvBTP.ID = "gvBTP";
        gvBTP.AutoGenerateColumns = true;

        gvBTP.DataSource = dt;
        gvBTP.CssClass = "table DataTable table-condensed table-bordered table-responsive";

        gvBTP.DataBind();
        if (dt != null && dt.Rows.Count > 0)
        {
            gvBTP.Rows[gvBTP.Rows.Count - 1].CssClass = "text-muted well well-sm no-shadow";
            gvBTP.Rows[gvBTP.Rows.Count - 1].Font.Bold = true;
            gvBTP.PreRender += gv_PreRender;
            BTPRating = Convert.ToDecimal(dt.Rows[0]["Rating"].ToString());
        }
        else
        {

        }
        ltlBTP.Text = "Billed To Pay &nbsp= &nbsp";
        pnlBTP.Controls.Add(gvBTP);
        ltl_BTP.Text = BTPRating.ToString();
    }
    public void fillpnl_Escalations(int ForEmpID)
    {
        EIRating = 0;
        strSQL = "[WFMPMS].[GetEscalationInitiativeScore]";
        using (SqlConnection cn = new SqlConnection(my.getConnectionString()))
        {
            cn.Open();
            using (SqlCommand cmd = new SqlCommand(strSQL, cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@EmpCode", ForEmpID);
                cmd.Parameters.AddWithValue("@PacmanCycle", PacmanCycle);
                cmd.Parameters.AddWithValue("@total", EIRating);
                cmd.Parameters["@total"].Direction = ParameterDirection.Output;
                cmd.ExecuteNonQuery();
                EIRating = Convert.ToInt32(cmd.Parameters["@total"].Value.ToString());
                ltlEI.Text = "Escalations & Initiatives &nbsp= &nbsp";
                ltl_Escalations.Text = EIRating.ToString();
            }

        }
    }
    public void fillpnl_Forecasting_Accuracy(int ForEmpID)
    {
        //WFMPMS.getForecastingAccuracyScore
        string strSQL = "WFMPMS.getForecastingAccuracyScore";

        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@EmpCode", ForEmpID);
        cmd.Parameters.AddWithValue("@StartDate", StartDate);
        cmd.Parameters.AddWithValue("@EndDate", EndDate);

        DataTable dt = my.GetDataTableViaProcedure(ref cmd);
        if (dt != null)
        {
            GridView gvForecastingAccuracy = new GridView();
            gvForecastingAccuracy.ID = "gvForecastingAccuracy";
            gvForecastingAccuracy.AutoGenerateColumns = true;
            //gvPrimaryKPI.EmptyDataTemplate =  "No data found matching this set of parameters " + MyEmpID + StartDate.Month.ToString("M");

            DataRow dr = dt.NewRow();

            gvForecastingAccuracy.DataSource = dt;
            gvForecastingAccuracy.CssClass = "table DataTable table-condensed table-bordered table-responsive";
            gvForecastingAccuracy.DataBind();
            if (dt.Rows.Count > 0)
            {
                gvForecastingAccuracy.Rows[gvForecastingAccuracy.Rows.Count - 1].CssClass = "text-muted well well-sm no-shadow";
                gvForecastingAccuracy.Rows[gvForecastingAccuracy.Rows.Count - 1].Font.Bold = true;
                gvForecastingAccuracy.PreRender += gv_PreRender;
                ForecastingAccuracy = Convert.ToDecimal(dt.Rows[dt.Rows.Count - 1]["Rating"].ToString());
                ltl_Forecasting_Accuracy.Text = ForecastingAccuracy.ToString();
            }


            pnlForecasting_Accuracy.Controls.Add(gvForecastingAccuracy);
        }
        else
        {
            ltl_Forecasting_Accuracy.Text = "Forecasting Accuracy &nbsp= &nbsp" + "No Data found";
        }
    }
    public void fillpnl_Headcount_Accuracy(int ForEmpID)
    {
        //WFMPMS.getHeadcountAccuracyScore
        string strSQL = "WFMPMS.getHeadCountAccuracyScore";

        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@EmpCode", ForEmpID);
        cmd.Parameters.AddWithValue("@StartDate", StartDate);
        cmd.Parameters.AddWithValue("@EndDate", EndDate);

        DataTable dt = my.GetDataTableViaProcedure(ref cmd);
        if (dt != null)
        {
            GridView gvHeadcountAccuracy = new GridView();
            gvHeadcountAccuracy.ID = "gvHeadcountAccuracy";
            gvHeadcountAccuracy.AutoGenerateColumns = true;
            //gvPrimaryKPI.EmptyDataTemplate =  "No data found matching this set of parameters " + MyEmpID + StartDate.Month.ToString("M");

            DataRow dr = dt.NewRow();

            gvHeadcountAccuracy.DataSource = dt;
            gvHeadcountAccuracy.CssClass = "table DataTable table-condensed table-bordered table-responsive";
            gvHeadcountAccuracy.DataBind();
            if (dt.Rows.Count > 0)
            {
                gvHeadcountAccuracy.Rows[gvHeadcountAccuracy.Rows.Count - 1].CssClass = "text-muted well well-sm no-shadow";
                gvHeadcountAccuracy.Rows[gvHeadcountAccuracy.Rows.Count - 1].Font.Bold = true;
                gvHeadcountAccuracy.PreRender += gv_PreRender;
                HeadcountAccuracy = Convert.ToDecimal(dt.Rows[dt.Rows.Count - 1]["Rating"].ToString());
                ltl_Headcount_Accuracy.Text = HeadcountAccuracy.ToString();
            }


            pnlHeadcount_Accuracy.Controls.Add(gvHeadcountAccuracy);
        }
        else
        {
            ltlHeadcount_Accuracy.Text = "Headcount Accuracy &nbsp= &nbsp" + "No Data found";
        }
    }
    #endregion
    #region RTA
    public void fillpnl_Real_Time_Optimization(int ForEmpID)
    {

        string strSQL = "WFMPMS.getSLOptimizationSummaryForPACMAN";

        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.Parameters.AddWithValue("@EmpCode", ForEmpID);
        cmd.Parameters.AddWithValue("@StartDate", StartDate);
        cmd.Parameters.AddWithValue("@EndDate", EndDate);

        DataTable dt = my.GetDataTableViaProcedure(ref cmd);
        if (dt.Rows.Count > 0)
        {
            GridView gvOptimizationKPI = new GridView();
            gvOptimizationKPI.AutoGenerateColumns = true;

            gvOptimizationKPI.DataSource = dt;
            gvOptimizationKPI.DataBind();
            gvOptimizationKPI.CssClass = "table DataTable table-condensed table-bordered table-responsive";
            gvOptimizationKPI.Rows[gvOptimizationKPI.Rows.Count - 1].CssClass = "text-muted well well-sm no-shadow";
            gvOptimizationKPI.Rows[gvOptimizationKPI.Rows.Count - 1].Font.Bold = true;
            OptimizationRating = Convert.ToDecimal(dt.Rows[dt.Rows.Count - 1]["Rating"].ToString());
            ltlOptimization.Text = "Real Time Optimization &nbsp= &nbsp";
            ltl_Real_Time_Optimization.Text = OptimizationRating.ToString();
            pnlOptimization.Controls.Add(gvOptimizationKPI);

            gvOptimizationKPI.PreRender += gv_PreRender;
        }


    }
    #endregion
    #region Scheduling
    public void fillpnl_Scheduling_Accuracy(int ForEmpID)
    {
        //WFMPMS.getSchedulingAccuracyScore
        string strSQL = "WFMPMS.getSchedulingAccuracyScore";

        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@EmpCode", ForEmpID);
        cmd.Parameters.AddWithValue("@StartDate", StartDate);
        cmd.Parameters.AddWithValue("@EndDate", EndDate);

        DataTable dt = my.GetDataTableViaProcedure(ref cmd);
        if (dt != null)
        {
            GridView gvSchedulingAccuracy = new GridView();
            gvSchedulingAccuracy.ID = "gvSchedulingAccuracy";
            gvSchedulingAccuracy.AutoGenerateColumns = true;
            //gvPrimaryKPI.EmptyDataTemplate =  "No data found matching this set of parameters " + MyEmpID + StartDate.Month.ToString("M");

            DataRow dr = dt.NewRow();

            gvSchedulingAccuracy.DataSource = dt;
            gvSchedulingAccuracy.CssClass = "table DataTable table-condensed table-bordered table-responsive";
            gvSchedulingAccuracy.DataBind();
            if (dt.Rows.Count > 0)
            {
                gvSchedulingAccuracy.Rows[gvSchedulingAccuracy.Rows.Count - 1].CssClass = "text-muted well well-sm no-shadow";
                gvSchedulingAccuracy.Rows[gvSchedulingAccuracy.Rows.Count - 1].Font.Bold = true;
                gvSchedulingAccuracy.PreRender += gv_PreRender;
                SchedulingAccuracy = Convert.ToDecimal(dt.Rows[dt.Rows.Count - 1]["Rating"].ToString());
                ltl_Scheduling_Accuracy.Text = SchedulingAccuracy.ToString();
            }


            pnlKPI.Controls.Add(gvSchedulingAccuracy);
        }
        else
        {
            ltl_Scheduling_Accuracy.Text = "Scheduling Accuracy &nbsp= &nbsp" + "No Data found";
        }
    }
    public void fillpnl_IEX_Management(int ForEmpID)
    {
        IEXMgmt = 0;
        strSQL = "[WFMPMS].[GetIEXMgmtScore]";
        using (SqlConnection cn = new SqlConnection(my.getConnectionString()))
        {
            cn.Open();
            using (SqlCommand cmd = new SqlCommand(strSQL, cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@EmpCode", ForEmpID);
                cmd.Parameters.AddWithValue("@PacmanCycle", PacmanCycle);
                SqlDataReader sdr = cmd.ExecuteReader();
                while (sdr.Read())
                {
                    if (sdr.HasRows)
                    {
                        IEXMgmt = Convert.ToInt32(sdr.GetValue(0));
                    }
                }
                ltlIEX_Management.Text = "IEX Management &nbsp= &nbsp";
                ltl_IEX_Management.Text = IEXMgmt.ToString();
            }

        }
    }
    #endregion

}