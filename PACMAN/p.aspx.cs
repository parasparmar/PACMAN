﻿using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data.Sql;
using System.Reflection;
using System.IO;
using CsvHelper;

public partial class p : System.Web.UI.Page
{
    DataTable dtEmp;
    Helper my;
    private string strSQL { get; set; }
    private int MyEmpID { get; set; }
    private int ForEmpID { get; set; }
    private int MyRepMgr { get; set; }
    private int PeriodID { get; set; }
    private int RStage { get; set; }
    private int IsRepMgr { get; set; }
    private int IsManager { get; set; }
    private int AttritionRating { get; set; }
    private string MySkillset { get; set; }
    private DateTime StartDate { get; set; }
    private DateTime EndDate { get; set; }
    private decimal SLRating { get; set; }
    private decimal OPRating { get; set; }
    private decimal OptimizationRating { get; set; }
    private decimal EIRating { get; set; }
    private decimal AbsenteeismRating { get; set; }
    private decimal SelfAbsenteeismRating { get; set; }
    private decimal TeamAbsenteeismRating { get; set; }
    private decimal BTPRating { get; set; }
    public string lblPacmanCycle { get; set; }
    public DataTable DtOfAccountsIHandle { get; set; }
    private int IEXMgmt { get; set; }
    private int Revenue { get; set; }
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
                int LevelID = Convert.ToInt32(dtEmp.Rows[0]["LevelIDnumber"].ToString());
                if (LevelID <= 80)
                    IsManager = 1;
                else
                    IsManager = 0;
            }
        }
        catch (Exception Ex)
        {
            Console.WriteLine(Ex.Message.ToString());
            Response.Redirect(ViewState["PreviousPageUrl"] != null ? ViewState["PreviousPageUrl"].ToString() : "index.aspx", false);
        }
        Literal title = (Literal)PageExtensionMethods.FindControlRecursive(Master, "ltlPageTitle");
        title.Text = "PACMAN Discussion";

        //btnSubmitPacman.Enabled = true;
        //btnYesDiscussed.Enabled = true;
        //btnIEXMgmtScoreSubmit.Enabled = true;
        //btnAnalyticProjectScoreSubmit.Enabled = true;
        //btnCoachingScoreSubmit.Enabled = true;
        //btnRevenue_and_Cost_optimization.Enabled = true;
        //btnSubmitPacman.Enabled = true;


        if (!IsPostBack)
        {
            fillddlReviewPeriod();
            fillddlStage();
            fillddlReportee();
            ddlStage_DataBound(sender, e);
            if (RStage == 3 || RStage == 4 || RStage == 5)
            {
                btnYesDiscussed.Enabled = false;
                
            }
            else if (RStage == 2)
            {
                btnYesDiscussed.Enabled = false;                
                btnSubmitPacman.Enabled = true;
            }
            else
            {
                btnYesDiscussed.Enabled = true;                
            }
            if (IsRepMgr == 0)
            {
                btnYesDiscussed.Enabled = false;                
            }

            DtOfAccountsIHandle = getDtOfAccountsIHandle(ForEmpID);
            ////////////////////////////////////////////////////////////////////show relevant metrics
            if (Convert.ToInt32(ltl_IEX_Management.Text) != 0)
            {
                btnIEXMgmtScoreSubmit.Enabled = false;
            }
            if (Convert.ToInt32(ltl_Project.Text) != 0)
            {
                btnAnalyticProjectScoreSubmit.Enabled = false;
            }
            if (Convert.ToInt32(ltl_Coaching_and_Feedback.Text) != 0)
            {
                btnCoachingScoreSubmit.Enabled = false;
            }
            if (Convert.ToInt32(ltl_Revenue_and_Cost_optimization.Text) != 0)
            {
                btnRevenue_and_Cost_optimization.Enabled = false;
            }
            btnIEXMgmtScoreSubmit.Enabled = true;
            btnAnalyticProjectScoreSubmit.Enabled = true;
            btnCoachingScoreSubmit.Enabled = true;
            btnRevenue_and_Cost_optimization.Enabled = true;

        }
    }
    private DataTable getDtOfAccountsIHandle(int ForEmpID)
    {
        string strSQL = "WFMPMS.GetAllAccountsIHandle";
        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.Parameters.AddWithValue("@Employee_ID", ForEmpID);
        StartDate = DateTime.Today.Date;
        //cmd.Parameters.AddWithValue("@StartDate", StartDate);

        DataTable dt = my.GetDataTableViaProcedure(ref cmd);
        //dt.DefaultView.RowFilter = "InBO=1";
        //gvAllMyAccounts.DataSource = dt;
        //gvAllMyAccounts.DataBind();

        return dt;
    }
    private void getFinalRating(int ForEmpID)
    {
        ForEmpID = Convert.ToInt32(ddlReportee.SelectedItem.Value.ToString());

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
                ltl.Text = (ltl.Text == "") ? "0" : ltl.Text;
                Decimal KPIScore = Convert.ToDecimal(ltl.Text);
                FinalRating = FinalRating + (KPIScore * KPIWt);
            }
        }
        ltlfinalScore.Text = FinalRating.ToString();

    }
    private void hideMetricPanels()
    {
        string strSQL1 = "Select distinct Metrics from [WFMPMS].[tblDsgn2KPIWtg]";
        DataTable dt1 = my.GetData(strSQL1);
        string myPanelName1 = string.Empty;

        foreach (DataRow d in dt1.Rows)
        {
            myPanelName1 = "pnl_" + d["Metrics"].ToString().Replace("&", "").Replace(" ", "_");
            Control c = Page.FindControlRecursive(myPanelName1);
            if (c != null)
            {
                Panel thePanel = c as Panel;
                thePanel.Visible = false;
            }
        }
    }
    private void showRelevantMetricPanels(int ForEmpID)
    {
        hideMetricPanels();

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
        string strSQL = "WFMPMS.GetPacmanCycleforPacmanDiscussion_g";
        SqlCommand cmd = new SqlCommand(strSQL);        
        DataTable dt = my.GetDataTableViaProcedure(ref cmd);
        ddlReviewPeriod.DataSource = dt;
        ddlReviewPeriod.DataTextField = "Period";
        ddlReviewPeriod.DataValueField = "PeriodID";
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
            //btnNotDiscussed.Enabled = false;
        }
        else if (RStage == 2)
        {
            btnYesDiscussed.Enabled = false;
            //btnNotDiscussed.Enabled = false;
            btnSubmitPacman.Enabled = true;
        }
        else
        {
            btnYesDiscussed.Enabled = true;
            // btnNotDiscussed.Enabled = true;
        }
    }
    protected void ddlReviewPeriod_SelectedIndexChanged(object sender, EventArgs e)
    {
        PeriodID = Convert.ToInt32(ddlReviewPeriod.SelectedValue);
        string strSQL = "SELECT [FromDate],[ToDate] FROM [CWFM_Umang].[WFMPMS].[tblPacmanCycle] where [ID] =" + PeriodID;
        DataTable dt = my.GetData(strSQL);
        StartDate = Convert.ToDateTime(dt.Rows[0]["FromDate"].ToString());
        EndDate = Convert.ToDateTime(dt.Rows[0]["ToDate"].ToString());
        fillddlStage();
        fillddlReportee();
        populateHeaders();

    }

    private void populateHeaders()
    {
        if (ddlReportee.Items.Count > 0 && ddlReportee.SelectedIndex > 0)
        {
            ltlEmployeeBanner.Text = ddlReportee.SelectedItem.Text.ToString() + "( " + ForEmpID + " ) Performance Management Cycle : " + ddlReviewPeriod.SelectedItem.Text.ToString();
        }
        else
        {
            ltlEmployeeBanner.Text = "Performance Management Cycle : " + ddlReviewPeriod.SelectedItem.Text.ToString();
        }
    }

    private void fillStartAndEndDates()
    {
        PeriodID = Convert.ToInt32(ddlReviewPeriod.SelectedValue);
        string strSQL = "SELECT [FromDate],[ToDate] FROM [CWFM_Umang].[WFMPMS].[tblPacmanCycle] where [ID] =" + PeriodID;
        DataTable dt = my.GetData(strSQL);
        if (dt != null && dt.Rows.Count > 0)
        {
            StartDate = Convert.ToDateTime(dt.Rows[0]["FromDate"].ToString());
            EndDate = Convert.ToDateTime(dt.Rows[0]["ToDate"].ToString());
        }
        else
        {
            StartDate = new DateTime(DateTime.Today.Year, DateTime.Today.Month, 1);
            EndDate = new DateTime(DateTime.Today.Year, DateTime.Today.Month, 31);
        }

    }
    private void fillddlReportee()
    {
        PeriodID = Convert.ToInt32(ddlReviewPeriod.SelectedValue);
        int stageNo = Convert.ToInt32(ddlStage.SelectedValue);

        string strSQL = "WFMPMS.fillEmployeePacmanDiscussion_g";
        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.Parameters.AddWithValue("@RepMgr", MyEmpID);        
        cmd.Parameters.AddWithValue("@PeriodID", PeriodID);
        DataTable dt2 = my.GetDataTableViaProcedure(ref cmd);
        ddlReportee.DataSource = dt2;
        ddlReportee.DataTextField = "Name";
        ddlReportee.DataValueField = "EmpCode";
        ddlReportee.DataBind();
        showRelevantMetricPanels(ForEmpID);
        //fillRelevantMetricsInPanels(ForEmpID);//////////////////////////////////////////
        //getFinalRating(ForEmpID);
    }
    private void fillRelevantMetricsInPanels(int ForEmpID)
    {
        if (ForEmpID == 0)
        {
           ForEmpID = Convert.ToInt32(ddlReportee.SelectedItem.Value.ToString());
        }
        hideMetricPanels();
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
                theMethod.Invoke(this, new object[] { ForEmpID });
            }
        }
    }
    protected void btnYesDiscussed_Click(object sender, EventArgs e)
    {
        btnIEXMgmtScoreSubmit.Enabled = false;
        btnAnalyticProjectScoreSubmit.Enabled = false;
        btnCoachingScoreSubmit.Enabled = false;
        btnRevenue_and_Cost_optimization.Enabled = false;

        btnSubmitPacman.Enabled = true;
        btnYesDiscussed.Enabled = false;

        SqlConnection con = new SqlConnection(my.getConnectionString());
        con.Open();

        String strSQL = "[WFMPMS].[InsertPacmanStage]";
        SqlCommand cmd = new SqlCommand(strSQL, con);
        cmd.CommandType = CommandType.StoredProcedure;

        MyEmpID = Convert.ToInt32(dtEmp.Rows[0]["Employee_Id"].ToString());
        int reportee = Convert.ToInt32(ddlReportee.SelectedItem.Value.ToString());
        //int PreviousStage = Convert.ToInt32(ddlStage.SelectedItem.Value.ToString());
        int PreviousStage = 1;
        int Stage = 2;
        PeriodID = Convert.ToInt32(ddlReviewPeriod.SelectedItem.Value.ToString());
        cmd.Parameters.AddWithValue("@EmpCode", reportee);
        cmd.Parameters.AddWithValue("@Stage", Stage);
        cmd.Parameters.AddWithValue("@PeriodID", PeriodID);
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
        InsertTotblFinalKPI(ForEmpID);

        btnYesDiscussed.Enabled = false;
        //btnNotDiscussed.Enabled = false;
        btnSubmitPacman.Enabled = false;

        SqlConnection con = new SqlConnection(my.getConnectionString());
        con.Open();

        String strSQL = "[WFMPMS].[InsertPacmanStage]";
        SqlCommand cmd = new SqlCommand(strSQL, con);
        cmd.CommandType = CommandType.StoredProcedure;

        MyEmpID = Convert.ToInt32(dtEmp.Rows[0]["Employee_Id"].ToString());
        int reportee = Convert.ToInt32(ddlReportee.SelectedItem.Value.ToString());
        //int PreviousStage = Convert.ToInt32(ddlStage.SelectedItem.Value.ToString());
        int PreviousStage = 2;
        int Stage = 3;
        PeriodID = Convert.ToInt32(ddlReviewPeriod.SelectedItem.Value.ToString());
        cmd.Parameters.AddWithValue("@EmpCode", reportee);
        cmd.Parameters.AddWithValue("@Stage", Stage);
        cmd.Parameters.AddWithValue("@PeriodID", PeriodID);
        cmd.Parameters.AddWithValue("@ActionBy", MyEmpID);
        cmd.Parameters.AddWithValue("@PreviousStage", PreviousStage);

        cmd.Connection = con;
        cmd.ExecuteNonQuery();
        con.Close();

        fillddlReportee();
    }
    private void InsertTotblFinalKPI(int ForEmpID)
    {
        int IsSPI = Convert.ToInt32(ddlSPI.SelectedValue.ToString());
        ForEmpID = Convert.ToInt32(ddlReportee.SelectedItem.Value.ToString());
        PeriodID = Convert.ToInt32(ddlReviewPeriod.SelectedValue);
        string strSQL = "SELECT [FromDate],[ToDate] FROM [CWFM_Umang].[WFMPMS].[tblPacmanCycle] where [ID] =" + PeriodID;
        DataTable dt = my.GetData(strSQL);
        StartDate = Convert.ToDateTime(dt.Rows[0]["FromDate"].ToString());

        strSQL = " SELECT Distinct B.Id, A.EmpCode,'' as PacmanCycle,B.SkillsetId, B.Metrics as Metric ";
        strSQL += " , B.DataLevel, B.Weight as Weightage, '' as Acheived, '' as Score";
        strSQL += " , getdate() as Date FROM[CWFM_Umang].[WFMPMS].[tblEmp2Account] A ";
        strSQL += " inner join[WFMPMS].[tblDsgn2KPIWtg] B on B.SkillsetId = A.SkillsetId ";
        strSQL += " where EmpCode = " + ForEmpID + " and[Active] = 1 and '" + StartDate + "' between A.FromDate and A.ToDate ";
        strSQL += " order by B.Id, B.Metrics, B.Weight ";

        FinalRating = 0;
        DataTable dtWeights = my.GetData(strSQL);
        strSQL = "[WFMPMS].[InsertFinalKPI]";

        foreach (DataRow dr in dtWeights.Rows)
        {
            Decimal KPIWt = Convert.ToDecimal(dr["Weightage"].ToString());
            string KPIname = dr["Metric"].ToString().Replace("&", "").Replace(" ", "_");
            Literal ltl = (Literal)Page.FindControlRecursive("ltl_" + KPIname);

            if (ltl != null)
            {

                Decimal KPIScore = Convert.ToDecimal(ltl.Text);
                if (IsSPI == 0)
                { FinalRating = KPIScore * KPIWt; }
                else { FinalRating = 3; }

                SqlCommand cmd = new SqlCommand(strSQL);
                cmd.Parameters.AddWithValue("@EmpCode", ForEmpID);
                cmd.Parameters.AddWithValue("@PeriodID", PeriodID);
                cmd.Parameters.AddWithValue("@SkillsetId", Convert.ToDecimal(dr["SkillsetId"].ToString()));
                cmd.Parameters.AddWithValue("@Metric", KPIname);
                cmd.Parameters.AddWithValue("@DataLevel", dr["DataLevel"].ToString());
                cmd.Parameters.AddWithValue("@Weightage", Convert.ToDecimal(dr["Weightage"].ToString()));
                cmd.Parameters.AddWithValue("@Achieved", KPIScore);
                cmd.Parameters.AddWithValue("@Score", FinalRating);
                my.ExecuteDMLCommand(ref cmd, strSQL, "S");
                cmd.Dispose();

            }
        }
    }
    private void clearIEXMgmtScorefields()
    {
        ddlIEXMgmtScore.ClearSelection();
        txtIEXMgmtComments.Text = string.Empty;
    }
    private void clearRevenueScorefields()
    {
        ddlRevenue_and_Cost_optimization.ClearSelection();
        tbRevenue_and_Cost_optimization.Text = string.Empty;
    }

    public void fillpnl_KPI(int ForEmpID)
    {

        /*
         * 0. Am I a manager or not. If so, WFMPMS.GetManagerKPI gets my rating directly.
         * 1. Get a list of my accounts.
         * 2. For these accounts what skillsets do i profess.
         * 3. If I am assigned more than 1 distinct skillsets (Planning, Scheduling or RTA) I'm out of scope.
         * 4. If I have one and only one distinct skillset assigned for all accounts I can proceed further.
         * 5. If my skillset is RTA, For each individual KPI run the WFMPMS.get<KPI>SummaryForPACMAN procedure exactly once.
         * 6. Merge the above datatables into one. Calculate the merged score as my Primary KPI Score.
         * 7. If I profess the planning or scheduling skillset, then just run the WFMPMS.getSLSummaryForPACMAN
         * contd. because that procedure contains the intelligence needed to pull data from KPI dashboard 
         * contd. for that month for all Accounts and KPIs.
         */

        if (IsManager == 1)
        {
            //0. Am I a manager or not. If so, WFMPMS.GetManagerKPI gets my rating directly.
            fillpnl_KPI_forManagers(ForEmpID);
        }

        else if (IsManager == 0)
        {

            //* 1. Get a list of my accounts.
            DtOfAccountsIHandle = getDtOfAccountsIHandle(ForEmpID);

            //* 2. For these accounts what skillsets do i profess.
            var myPrimaryKPIs = DtOfAccountsIHandle.AsEnumerable()
                .Where(s => s.Field<string>("PrimaryKPI") != null)
                .Select(s => new { kpi = s.Field<string>("PrimaryKPI") })
                .Distinct();

            //3.If I am assigned more than 1 distinct skillsets(Planning, Scheduling or RTA) I'm out of scope.
            var mySkillsets = DtOfAccountsIHandle.AsEnumerable()
                .Select(t => t.Field<int>("SkillsetId")).Distinct();



            //*4.If I have one and only one distinct skillset assigned for all accounts I can proceed further.
            if (mySkillsets.Count() == 1)
            {
                fillStartAndEndDates();
                SqlCommand cmd = new SqlCommand();
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@EmpCode", ForEmpID);
                cmd.Parameters.AddWithValue("@StartDate", StartDate);
                cmd.Parameters.AddWithValue("@EndDate", EndDate);

                DataTable dt = new DataTable();
                GridView gvPrimaryKPI = new GridView();
                if (mySkillsets.FirstOrDefault() == 2 || mySkillsets.FirstOrDefault() == 3)
                {
                    cmd.CommandText = "WFMPMS.getSLSummaryForPACMAN";
                    dt = my.GetDataTableViaProcedure(ref cmd);
                }
                else if (mySkillsets.FirstOrDefault() == 4)
                {

                    int i = 0;
                    foreach (var individualKPI in myPrimaryKPIs)
                    {
                        cmd.CommandText = "WFMPMS.get" + individualKPI.kpi.ToString() + "SummaryForPACMAN";

                        if (i == 0)
                        {
                            dt = my.GetDataTableViaProcedure(ref cmd);
                            dt.Columns["PrimaryKPI"].AllowDBNull = true;
                            dt.Columns["AccountId"].AllowDBNull = true;
                            dt.Columns["Rating"].AllowDBNull = true;
                            dt.Columns["Occurence"].AllowDBNull = true;
                            dt.Columns["RatingxOccurence"].AllowDBNull = true;
                            dt.Columns["Calculation"].AllowDBNull = true;
                            dt.Columns["PrimaryKPI"].MaxLength = 500;
                            i++;
                        }
                        else
                        {
                            DataTable dttemp = new DataTable();
                            dttemp = my.GetDataTableViaProcedure(ref cmd);

                            foreach (DataRow r in dttemp.Rows)
                            {
                                KPISummary j = new KPISummary();
                                j.AccountId = r["AccountId"].ToString();
                                j.Account = r["Account"].ToString();
                                j.PrimaryKPI = r["PrimaryKPI"].ToString();
                                j.PrimaryKPITarget = Convert.ToDecimal(r["PrimaryKPITarget"].ToString());
                                if (r["Rating"].ToString() == "")
                                { j.Rating = 0; }
                                else
                                {
                                    j.Rating = Convert.ToDecimal(r["Rating"].ToString());
                                }
                                if (r["RatingxOccurence"].ToString() == "")
                                {
                                    j.RatingxOccurence = 0;
                                }
                                else
                                {
                                    j.RatingxOccurence = Convert.ToInt32(r["RatingxOccurence"].ToString());
                                }
                                j.Calculation = r["Calculation"].ToString();

                                DataRow k = dt.NewRow();
                                k["AccountId"] = j.AccountId;
                                k["Account"] = j.Account;
                                k["PrimaryKPI"] = j.PrimaryKPI;
                                k["PrimaryKPITarget"] = j.PrimaryKPITarget;
                                k["Rating"] = j.Rating;
                                k["Occurence"] = j.Occurence;
                                k["RatingxOccurence"] = j.RatingxOccurence;
                                k["Calculation"] = j.Calculation;
                                dt.Rows.Add(k);
                            }
                            dttemp.Clear();
                            i++;
                        }
                    }
                    dt = ConsolidateDataTables(ref dt);
                }
                else
                {
                    ltlPrimaryKPI.Text = "Multiple Roles found. The total KPI score for this employee will lead to an invalid condition (greater than 5)";
                    ltl_KPI.Text = String.Empty;
                }
                if (dt != null && dt.Rows.Count > 0) { populateGvPrimaryKPI(dt); }
            }
        }
    }
    private DataTable ConsolidateDataTables(ref DataTable dt)
    {
        if (dt.Rows.Count > 1)
        {
            var h = from r in dt.AsEnumerable()
                    group r by new
                    {
                        accountid = r["AccountId"],
                        account = r["Account"],
                        primarykpi = r["PrimaryKPI"],
                        primarykpitarget = r["PrimaryKPITarget"],
                        rating = r["Rating"]
                    } into groupby
                    where groupby.Key.account.ToString().Contains("Total") != true
                    select new
                    {
                        accountid = groupby.Key.accountid,
                        account = groupby.Key.account,
                        primarykpi = groupby.Key.primarykpi,
                        primarykpitarget = groupby.Key.primarykpitarget,
                        rating = groupby.Key.rating,
                        occurence = groupby.Sum(r => r.Field<int?>("Occurence")),
                        calculation = groupby.ElementAtOrDefault(6)

                    };
            var g = h.ToList();
            DataTable dt1 = dt.Clone();
            foreach (var f in g)
            {
                //if(f.account!=null && f.account.ToString().Contains("Total") != true)
                //{
                DataRow r = dt1.NewRow();
                string accountid = ".";
                if (f.accountid != null && f.accountid.ToString().Length > 0) { accountid = f.accountid.ToString(); }
                r["AccountId"] = accountid;
                r["Account"] = f.account;
                r["PrimaryKPI"] = f.primarykpi;
                r["PrimaryKPITarget"] = f.primarykpitarget;
                int rating = 0;
                if (f.rating != null && f.rating.ToString().Length > 0) { rating = Convert.ToInt32(f.rating); }
                r["Rating"] = rating;
                int occurence = 0;
                if (f.occurence != null && f.occurence.ToString().Length > 0) { occurence = Convert.ToInt32(f.occurence); }
                r["Occurence"] = occurence;
                r["RatingxOccurence"] = rating * occurence;
                r["Calculation"] = string.Empty;

                dt1.Rows.Add(r);
                //}                        
            }


            DataRow s = dt1.NewRow();
            var a = dt1.AsEnumerable();
            s["AccountID"] = ".";
            s["Account"] = "Grand Total";
            s["PrimaryKPITarget"] = 0;
            int occurences = a.Sum(x => x.Field<int>("Occurence"));
            s["Occurence"] = occurences;
            var sumOfRatings = dt1.Compute("Sum(RatingxOccurence)", "").ToString();
            Decimal ratingxoccurence = 0;
            if (sumOfRatings.Length > 0)
            {
                ratingxoccurence = Convert.ToDecimal(sumOfRatings);
            }
            else
            {
                ratingxoccurence = 0;
            }
            s["RatingxOccurence"] = ratingxoccurence;
            if (occurences > 0) { s["Rating"] = Math.Round(ratingxoccurence / occurences, 2); } else { s["Rating"] = 0; }
            s["Calculation"] = "(RatingxOccurence)/Occurence";

            dt1.Rows.Add(s);
            return dt1;
        }
        else
        {
            return dt;
        }
    }
    private void fillpnl_KPI_forManagers(int ForEmpID, string metric = "KPI")
    {
        string strSQL = "WFMPMS.GetManagerKPI";
        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@EmpCode", ForEmpID);
        cmd.Parameters.AddWithValue("@StartDate", StartDate);
        cmd.Parameters.AddWithValue("@EndDate", EndDate);
        cmd.Parameters.AddWithValue("@Metric", metric);
        DataTable dt1 = my.GetDataTableViaProcedure(ref cmd);
        if (dt1 != null)
        {
            populateGvPrimaryKPI(dt1);
        }

    }

    private void populateGvPrimaryKPI(DataTable dt)
    {
        if (dt != null)
        {
            GridView gvPrimaryKPI = new GridView();
            gvPrimaryKPI.ID = "gvPrimaryKPI";
            gvPrimaryKPI.AutoGenerateColumns = true;
            gvPrimaryKPI.DataSource = dt;
            gvPrimaryKPI.CssClass = "table DataTable table-condensed table-bordered table-responsive";

            gvPrimaryKPI.DataBind();
            if (dt != null && dt.Rows.Count > 0)
            {
                gvPrimaryKPI.Rows[dt.Rows.Count - 1].CssClass = "text-muted well well-sm no-shadow";
                gvPrimaryKPI.Rows[dt.Rows.Count - 1].Font.Bold = true;
                gvPrimaryKPI.PreRender += gv_PreRender;
                bool slrating = false;
                decimal dec_slrating;
                slrating = Decimal.TryParse(dt.Rows[dt.Rows.Count - 1]["Rating"].ToString(), out dec_slrating);
                if (slrating)
                {
                    SLRating += dec_slrating;
                }
                else
                {
                    SLRating += 0;
                }
                ltlPrimaryKPI.Text = "Primary KPI &nbsp= &nbsp";
                ltl_KPI.Text = Math.Round(SLRating, 2).ToString();
                pnlKPI.Controls.Add(gvPrimaryKPI);
            }
            else
            {
                ltlPrimaryKPI.Text = "Primary KPI &nbsp= &nbsp";// + "No Data found";
                ltl_KPI.Text = String.Empty;
            }

        }
        else
        {
            ltlPrimaryKPI.Text = "Primary KPI &nbsp= &nbsp";// + "No Data found";
            ltl_KPI.Text = String.Empty;
        }
    }
    protected void btnIEXMgmtScoreSubmit_Click(object sender, EventArgs e)
    {
        SqlConnection con = new SqlConnection(my.getConnectionString());
        con.Open();

        String strSQL = "[WFMPMS].[InsertIEXManagementScore]";
        SqlCommand cmd = new SqlCommand(strSQL, con);
        cmd.CommandType = CommandType.StoredProcedure;
        PeriodID = Convert.ToInt32(ddlReviewPeriod.SelectedItem.Value.ToString());
        int reportee = Convert.ToInt32(ddlReportee.SelectedItem.Value.ToString());
        int score = Convert.ToInt32(ddlIEXMgmtScore.SelectedItem.Value.ToString());
        string comments = txtIEXMgmtComments.Text.ToString();

        cmd.Parameters.AddWithValue("@PeriodID", PeriodID);
        cmd.Parameters.AddWithValue("@EmpCode", reportee);
        cmd.Parameters.AddWithValue("@Score", score);
        cmd.Parameters.AddWithValue("@Comments", comments);
        cmd.Parameters.AddWithValue("@ActionedBy", MyEmpID);
        cmd.Connection = con;
        cmd.ExecuteNonQuery();
        con.Close();
        ltlIEX_Management.Text = "IEX Management &nbsp= &nbsp";
        ltl_IEX_Management.Text = score.ToString();
        clearIEXMgmtScorefields();
    }
    protected void ddlReportee_SelectedIndexChanged(object sender, EventArgs e)
    {
        ForEmpID = Convert.ToInt32(ddlReportee.SelectedItem.Value.ToString());
        string strSQL1 = "wfmpms.getLevelID";
        using (SqlConnection cn = new SqlConnection(my.getConnectionString()))
        {
            cn.Open();
            using (SqlCommand cmd = new SqlCommand(strSQL1, cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@EmpCode", ForEmpID);
                SqlDataReader sdr = cmd.ExecuteReader();
                while (sdr.Read())
                {
                    if (sdr.HasRows)
                    {
                        int LevelID = Convert.ToInt32(sdr.GetValue(0));
                        if (LevelID <= 80)
                            IsManager = 1;
                        else
                            IsManager = 0;
                    }
                    //else
                    //{
                    //    int noVal = 0;
                    //    ltlAccuracy.Text = noVal.ToString();
                    //    ltl_Accuracy.Text = noVal.ToString();
                    //}
                }
                //ltlAccuracy.Text = "Accuracy &nbsp= &nbsp" + "<div class=\"pull-right header\">" + Accuracy + "</div>";
            }
            populateHeaders();
        }
        PeriodID = Convert.ToInt32(ddlReviewPeriod.SelectedValue);
        string strSQL = "SELECT [FromDate],[ToDate] FROM [CWFM_Umang].[WFMPMS].[tblPacmanCycle] where [ID] =" + PeriodID;
        DataTable dt = my.GetData(strSQL);
        StartDate = Convert.ToDateTime(dt.Rows[0]["FromDate"].ToString());
        EndDate = Convert.ToDateTime(dt.Rows[0]["ToDate"].ToString());
        //fillRelevantMetricsInPanels(ForEmpID);
        //getFinalRating(ForEmpID);
        //if (Convert.ToInt32(ltl_IEX_Management.Text) != 0)
        //{
        //    btnIEXMgmtScoreSubmit.Enabled = false;
        //}
    }
    protected void btnAnalyticProjectScoreSubmit_Click(object sender, EventArgs e)
    {
        SqlConnection con = new SqlConnection(my.getConnectionString());
        con.Open();

        String strSQL = "[WFMPMS].[InsertAnalyticsProjectsScore]";
        SqlCommand cmd = new SqlCommand(strSQL, con);
        cmd.CommandType = CommandType.StoredProcedure;
        PeriodID = Convert.ToInt32(ddlReviewPeriod.SelectedItem.Value.ToString());
        int reportee = Convert.ToInt32(ddlReportee.SelectedItem.Value.ToString());
        int scoreProjects = Convert.ToInt32(ddlAnalyticProject.SelectedItem.Value.ToString());
        string commentsProjects = txtAnalyticProject.Text.ToString();

        cmd.Parameters.AddWithValue("@PeriodID", PeriodID);
        cmd.Parameters.AddWithValue("@EmpCode", reportee);
        cmd.Parameters.AddWithValue("@Score", scoreProjects);
        cmd.Parameters.AddWithValue("@Comments", commentsProjects);
        cmd.Parameters.AddWithValue("@ActionedBy", MyEmpID);
        cmd.Connection = con;
        cmd.ExecuteNonQuery();
        con.Close();
        ltl_Project.Text = scoreProjects.ToString();
        //ltlProject.Text = "Projects &nbsp= &nbsp" + "<div class=\"pull-right header\">" + scoreProjects + "</div>";
        clearAnalyticProjectScorefields();
        fillltlfinalScore(ForEmpID);

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
        PeriodID = Convert.ToInt32(ddlReviewPeriod.SelectedItem.Value.ToString());
        int reportee = Convert.ToInt32(ddlReportee.SelectedItem.Value.ToString());
        int scoreCoaching = Convert.ToInt32(ddlCoaching.SelectedItem.Value.ToString());
        string commentsCoaching = txtCoachingComments.Text.ToString();

        cmd.Parameters.AddWithValue("@PeriodID", PeriodID);
        cmd.Parameters.AddWithValue("@EmpCode", reportee);
        cmd.Parameters.AddWithValue("@Score", scoreCoaching);
        cmd.Parameters.AddWithValue("@Comments", commentsCoaching);
        cmd.Parameters.AddWithValue("@ActionedBy", MyEmpID);
        cmd.Connection = con;
        cmd.ExecuteNonQuery();
        con.Close();
        ltlCoachingFeedback.Text = "Coaching & Feedback &nbsp= &nbsp" + "<div class=\"pull-right header\">" + scoreCoaching + "</div>";
        clearAnalyticCoachingScorefields();
        fillltlfinalScore(ForEmpID);
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
                cmd.Parameters.AddWithValue("@PeriodID", PeriodID);
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
    #region Analytics KPIs
    public void fillpnl_Coaching_and_Feedback(int ForEmpID)
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
                cmd.Parameters.AddWithValue("@PeriodID", PeriodID);
                SqlDataReader sdr = cmd.ExecuteReader();
                while (sdr.Read())
                {
                    if (sdr.HasRows)
                    {
                        //string AnalyticCoaching =  sdr.GetValue(0).ToString();// Convert.ToInt32(sdr.GetValue(0));
                        AnalyticCoaching = Convert.ToInt32(sdr.GetValue(0));
                        ltlCoachingFeedback.Text = "Coaching & Feedback &nbsp= &nbsp";
                        ltl_Coaching_and_Feedback.Text = AnalyticCoaching.ToString();

                        //if (AnalyticCoaching != null)
                        //{
                        //    ltlCoachingFeedback.Text = "Coaching & Feedback &nbsp= &nbsp";
                        //    ltl_Coaching_and_Feedback.Text = AnalyticCoaching.ToString();
                        //}

                    }
                    else
                    {
                        int noVal = 0;
                        ltlCoachingFeedback.Text = noVal.ToString();
                        ltl_Coaching_and_Feedback.Text = noVal.ToString();
                    }
                }

            }

        }
    }
    public void fillpnl_On_Time_Delivery(int ForEmpID)
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
                cmd.Parameters.AddWithValue("@PeriodID", PeriodID);
                SqlDataReader sdr = cmd.ExecuteReader();
                while (sdr.Read())
                {
                    if (sdr.HasRows)
                    {
                        string val = sdr.GetValue(0).ToString();
                        //AnalyticTimeline = Convert.ToInt32(sdr.GetValue(0));
                        if (val != null)
                        {
                            ltlOntimeDelivery.Text = "On Time Delivery &nbsp= &nbsp";
                            ltl_On_time_Delivery.Text = val.ToString();
                        }
                        else
                        {
                            int noVal = 0;
                            ltlOntimeDelivery.Text = noVal.ToString();
                            ltl_On_time_Delivery.Text = noVal.ToString();
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


        //AbsenteeismRating = 0;
        //strSQL = "[WFMPMS].[GetSelfAttendanceScore]";
        //using (SqlConnection cn = new SqlConnection(my.getConnectionString()))
        //{
        //    cn.Open();
        //    using (SqlCommand cmd = new SqlCommand(strSQL, cn))
        //    {
        //        cmd.CommandType = CommandType.StoredProcedure;
        //        cmd.Parameters.AddWithValue("@EmpCode", ForEmpID);
        //        cmd.Parameters.AddWithValue("@PeriodID", PacmanCycle);
        //        SqlDataReader sdr = cmd.ExecuteReader();
        //        while (sdr.Read())
        //        {
        //            if (sdr.HasRows)
        //            {
        //                AbsenteeismRating = Convert.ToInt32(sdr.GetValue(0));
        //                ltlAbsenteeism.Text = "Self-Attendance &nbsp= &nbsp";
        //                ltl_Absenteeism.Text = AbsenteeismRating.ToString();
        //            }
        //            else
        //            {
        //                int noVal = 0;
        //                ltlAbsenteeism.Text = noVal.ToString();
        //                ltl_Absenteeism.Text = noVal.ToString();
        //            }
        //        }

        //    }

        //}



        AbsenteeismRating = 0;
        strSQL = "[WFMPMS].[GetSelfAttendanceScore]";
        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@EmpCode", ForEmpID);
        cmd.Parameters.AddWithValue("@StartDate", StartDate);
        cmd.Parameters.AddWithValue("@EndDate", EndDate);
        DataTable dt = my.GetDataTableViaProcedure(ref cmd);

        GridView gvAbsenteeism = new GridView();
        gvAbsenteeism.ID = "gvAbsenteeism";
        gvAbsenteeism.AutoGenerateColumns = true;

        gvAbsenteeism.DataSource = dt;
        gvAbsenteeism.CssClass = "table DataTable table-condensed table-bordered table-responsive";

        gvAbsenteeism.DataBind();
        if (dt != null && dt.Rows.Count > 0)
        {
            gvAbsenteeism.RowStyle.CssClass = "text-muted well well-sm no-shadow";
            gvAbsenteeism.Rows[0].Font.Bold = true;
            gvAbsenteeism.PreRender += gv_PreRender;
            string absRating = dt.Rows[0]["Final_Score"].ToString();
            ltl_Absenteeism.Text = absRating;
        }
        else
        {
            ltlAbsenteeism.Text = string.Empty;
        }
        ltlAbsenteeism.Text = "Self-Attendance &nbsp= &nbsp";
        pnlAbsenteeism.Controls.Add(gvAbsenteeism);
        //ltl_Absenteeism.Text = AbsenteeismRating.ToString();
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
                cmd.Parameters.AddWithValue("@PeriodID", PeriodID);
                SqlDataReader sdr = cmd.ExecuteReader();
                while (sdr.Read())
                {
                    if (sdr.HasRows)
                    {
                        Accuracy = Convert.ToInt32(sdr.GetValue(0));
                        ltlAccuracy.Text = "Accuracy &nbsp= &nbsp";
                        ltl_Accuracy.Text = Accuracy.ToString();
                    }
                    else
                    {
                        int noVal = 0;
                        ltlAccuracy.Text = noVal.ToString();
                        ltl_Accuracy.Text = noVal.ToString();
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
                cmd.Parameters.AddWithValue("@PeriodID", PeriodID);
                SqlDataReader sdr = cmd.ExecuteReader();
                while (sdr.Read())
                {
                    if (sdr.HasRows)
                    {
                        AnalyticProject = Convert.ToInt32(sdr.GetValue(0));
                        ltlProject.Text = "Projects &nbsp= &nbsp";
                        ltl_Project.Text = AnalyticProject.ToString();
                    }
                    else
                    {
                        int noVal = 0;
                        ltlProject.Text = noVal.ToString();
                        ltl_Project.Text = noVal.ToString();
                    }

                }

            }

        }
    }
    #endregion Analytics KPIs
    #region Manager
    public void fillpnl_Attrition(int ForEmpID)
    {

        string strSQL1 = "[WFMPMS].[getAttritionScore]";

        SqlCommand cmd1 = new SqlCommand(strSQL1);
        cmd1.CommandType = CommandType.StoredProcedure;
        cmd1.Parameters.AddWithValue("@EmpCode", ForEmpID);
        cmd1.Parameters.AddWithValue("@StartDate", StartDate);
        cmd1.Parameters.AddWithValue("@EndDate", EndDate);
        //cmd1.Parameters.AddWithValue("@Metric", metric);

        DataTable dt1 = my.GetDataTableViaProcedure(ref cmd1);
        if (dt1 != null)
        {
            GridView gvAttrition = new GridView();
            gvAttrition.ID = "gvAttrition";
            gvAttrition.AutoGenerateColumns = true;
            //gvPrimaryKPI.EmptyDataTemplate =  "No data found matching this set of parameters " + ForEmpID + StartDate.Month.ToString("M");

            DataRow dr1 = dt1.NewRow();

            gvAttrition.DataSource = dt1;
            gvAttrition.CssClass = "table DataTable table-condensed table-bordered table-responsive";
            gvAttrition.DataBind();
            if (dt1.Rows.Count > 0)
            {
                gvAttrition.Rows[gvAttrition.Rows.Count - 1].CssClass = "text-muted well well-sm no-shadow";
                gvAttrition.Rows[gvAttrition.Rows.Count - 1].Font.Bold = true;
                gvAttrition.PreRender += gv_PreRender;
                //SLRating = Convert.ToDecimal(dt1.Rows[dt1.Rows.Count - 1]["Metric_Score"].ToString());
                AttritionRating = Convert.ToInt32(dt1.Rows[dt1.Rows.Count - 1]["Attrited"].ToString());
                ltlAttrition.Text = "Attrition Rating = ";
                pnlAttrition.Controls.Add(gvAttrition);
                ltl_Attrition.Text = AttritionRating.ToString();
            }
        }
    }
    public void fillpnl_Team_Absenteeism(int ForEmpID)
    {
        string metric = "Absenteeism";
        string strSQL1 = "[WFMPMS].[GetManagerKPI]";

        SqlCommand cmd1 = new SqlCommand(strSQL1);
        cmd1.CommandType = CommandType.StoredProcedure;
        cmd1.Parameters.AddWithValue("@EmpCode", ForEmpID);
        cmd1.Parameters.AddWithValue("@StartDate", StartDate);
        cmd1.Parameters.AddWithValue("@EndDate", EndDate);
        cmd1.Parameters.AddWithValue("@Metric", metric);

        DataTable dt1 = my.GetDataTableViaProcedure(ref cmd1);
        if (dt1 != null)
        {
            GridView gvTeamAbsenteeism = new GridView();
            gvTeamAbsenteeism.ID = "gvTeamAbsenteeism";
            gvTeamAbsenteeism.AutoGenerateColumns = true;
            //gvPrimaryKPI.EmptyDataTemplate =  "No data found matching this set of parameters " + ForEmpID + StartDate.Month.ToString("M");

            DataRow dr1 = dt1.NewRow();

            gvTeamAbsenteeism.DataSource = dt1;
            gvTeamAbsenteeism.CssClass = "table DataTable table-condensed table-bordered table-responsive";
            gvTeamAbsenteeism.DataBind();
            if (dt1.Rows.Count > 0)
            {
                gvTeamAbsenteeism.Rows[gvTeamAbsenteeism.Rows.Count - 1].CssClass = "text-muted well well-sm no-shadow";
                gvTeamAbsenteeism.Rows[gvTeamAbsenteeism.Rows.Count - 1].Font.Bold = true;
                gvTeamAbsenteeism.PreRender += gv_PreRender;
                //SLRating = Convert.ToDecimal(dt1.Rows[dt1.Rows.Count - 1]["Metric_Score"].ToString());
                TeamAbsenteeismRating = Convert.ToDecimal(dt1.Rows[dt1.Rows.Count - 1]["Metric_Score"].ToString());
                ltlTeam_Absenteeism.Text = "Team Absenteeism = ";
                pnlTeam_Absenteeism.Controls.Add(gvTeamAbsenteeism);
                ltl_Team_Absenteeism.Text = TeamAbsenteeismRating.ToString();
            }
        }
    }
    public void fillpnl_Self_Absenteeism(int ForEmpID)
    {
        SelfAbsenteeismRating = 0;
        strSQL = "[WFMPMS].[GetSelfAttendanceScore]";
        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@EmpCode", ForEmpID);
        cmd.Parameters.AddWithValue("@StartDate", StartDate);
        cmd.Parameters.AddWithValue("@EndDate", EndDate);
        DataTable dt = my.GetDataTableViaProcedure(ref cmd);

        GridView gvSelfAbsenteeism = new GridView();
        gvSelfAbsenteeism.ID = "gvSelfAbsenteeism";
        gvSelfAbsenteeism.AutoGenerateColumns = true;

        gvSelfAbsenteeism.DataSource = dt;
        gvSelfAbsenteeism.CssClass = "table DataTable table-condensed table-bordered table-responsive";

        gvSelfAbsenteeism.DataBind();
        if (dt != null && dt.Rows.Count > 0)
        {
            gvSelfAbsenteeism.Rows[gvSelfAbsenteeism.Rows.Count - 1].CssClass = "text-muted well well-sm no-shadow";
            gvSelfAbsenteeism.Rows[gvSelfAbsenteeism.Rows.Count - 1].Font.Bold = true;
            gvSelfAbsenteeism.PreRender += gv_PreRender;
            string absRating = dt.Rows[dt.Rows.Count - 1]["Rating"].ToString();
            Decimal dcAbsRting = 5;
            Decimal.TryParse(absRating, out dcAbsRting);
            SelfAbsenteeismRating = dcAbsRting;
        }
        else
        {
            ltlSelf_Absenteeism.Text = string.Empty;
        }
        ltlSelf_Absenteeism.Text = "Self-Attendance &nbsp= &nbsp";
        pnlSelf_Absenteeism.Controls.Add(gvSelfAbsenteeism);
        ltl_Self_Absenteeism.Text = AbsenteeismRating.ToString();
    }
    //fillpnl_Revenue_and_Cost_optimization - post correction
    //fillpnl_Revenue_Cost_optimization - earlier
    public void fillpnl_Revenue_and_Cost_optimization(int ForEmpID)
    {
        Revenue = 0;
        strSQL = "[WFMPMS].[GetRevenueScore]";
        using (SqlConnection cn = new SqlConnection(my.getConnectionString()))
        {
            cn.Open();
            using (SqlCommand cmd = new SqlCommand(strSQL, cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@EmpCode", ForEmpID);
                cmd.Parameters.AddWithValue("@PeriodID", PeriodID);
                SqlDataReader sdr = cmd.ExecuteReader();
                while (sdr.Read())
                {
                    if (sdr.HasRows)
                    {
                        Revenue = Convert.ToInt32(sdr.GetValue(0));
                    }
                }
                ltlRevenue_and_Cost_optimization.Text = "Revenue & Cost Optimization &nbsp= &nbsp";
                ltl_Revenue_and_Cost_optimization.Text = Revenue.ToString();
            }
            //btnRevenue_and_Cost_optimization.Enabled = false;
        }
    }
    #endregion
    #region Planning
    public void fillpnl_BTP(int ForEmpID)
    {
        string metric = "BTP";
        if (IsManager == 1)
        {
            string strSQL1 = "[WFMPMS].[GetManagerKPI]";

            SqlCommand cmd1 = new SqlCommand(strSQL1);
            cmd1.CommandType = CommandType.StoredProcedure;
            cmd1.Parameters.AddWithValue("@EmpCode", ForEmpID);
            cmd1.Parameters.AddWithValue("@StartDate", StartDate);
            cmd1.Parameters.AddWithValue("@EndDate", EndDate);
            cmd1.Parameters.AddWithValue("@Metric", metric);

            DataTable dt1 = my.GetDataTableViaProcedure(ref cmd1);
            if (dt1 != null)
            {
                GridView gvBTP = new GridView();
                gvBTP.ID = "gvBTP";
                gvBTP.AutoGenerateColumns = true;
                //gvPrimaryKPI.EmptyDataTemplate =  "No data found matching this set of parameters " + ForEmpID + StartDate.Month.ToString("M");

                DataRow dr1 = dt1.NewRow();

                gvBTP.DataSource = dt1;
                gvBTP.CssClass = "table DataTable table-condensed table-bordered table-responsive";
                gvBTP.DataBind();
                if (dt1.Rows.Count > 0)
                {
                    gvBTP.Rows[gvBTP.Rows.Count - 1].CssClass = "text-muted well well-sm no-shadow";
                    gvBTP.Rows[gvBTP.Rows.Count - 1].Font.Bold = true;
                    gvBTP.PreRender += gv_PreRender;
                    //SLRating = Convert.ToDecimal(dt1.Rows[dt1.Rows.Count - 1]["Metric_Score"].ToString());
                    BTPRating = Convert.ToDecimal(dt1.Rows[dt1.Rows.Count - 1]["Metric_Score"].ToString());
                    ltlBTP.Text = "BTP : Billed To Pay Ratio = ";
                    pnlBTP.Controls.Add(gvBTP);
                    ltl_BTP.Text = BTPRating.ToString();
                }
                pnlBTP.Controls.Add(gvBTP);
            }
        }
        else
        {
            PeriodID = Convert.ToInt32(ddlReviewPeriod.SelectedValue);
            string strSQL = "SELECT [FromDate],[ToDate] FROM [CWFM_Umang].[WFMPMS].[tblPacmanCycle] where [ID] =" + PeriodID;
            DataTable dt = my.GetData(strSQL);
            StartDate = Convert.ToDateTime(dt.Rows[0]["FromDate"].ToString());


            strSQL = "[WFMPMS].[getBTPSummaryForPACMAN]";
            SqlCommand cmd = new SqlCommand(strSQL);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@EmpCode", ForEmpID);
            cmd.Parameters.AddWithValue("@Month", StartDate);
            dt = my.GetDataTableViaProcedure(ref cmd);


            GridView gvBTP = new GridView();
            gvBTP.ID = "gvBTP";
            gvBTP.AutoGenerateColumns = true;

            gvBTP.DataSource = dt;
            gvBTP.CssClass = "table DataTable table-condensed table-bordered table-responsive";


            if (dt != null && dt.Rows.Count > 0)
            {

                if (dt.Rows[0]["Rating"] != null && dt.Rows[0]["Rating"].ToString().Length > 0)
                {

                    BTPRating = Convert.ToDecimal(dt.Rows[dt.Rows.Count - 1]["Rating"].ToString());
                    dt.Rows[dt.Rows.Count - 1].Delete();
                }
                else
                {
                    BTPRating = 0;
                }
                gvBTP.DataBind();
                gvBTP.Rows[gvBTP.Rows.Count - 1].CssClass = "text-muted well well-sm no-shadow";
                gvBTP.Rows[gvBTP.Rows.Count - 1].Font.Bold = true;
                gvBTP.PreRender += gv_PreRender;

            }
            else
            {
                ltlBTP.Text = string.Empty;
            }
            ltlBTP.Text = "Billed To Pay &nbsp: &nbsp";
            pnlBTP.Controls.Add(gvBTP);
            ltl_BTP.Text = BTPRating.ToString();
        }
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
                cmd.Parameters.AddWithValue("@PeriodID", PeriodID);
                cmd.Parameters.AddWithValue("@total", EIRating);
                cmd.Parameters["@total"].Direction = ParameterDirection.Output;
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                EIRating = Convert.ToInt32(cmd.Parameters["@total"].Value.ToString());
                ltlEI.Text = "Escalations & Initiatives &nbsp= &nbsp";
                ltl_Escalations.Text = EIRating.ToString();

                if (dt != null)
                {
                    GridView gvEscalations = new GridView();
                    gvEscalations.ID = "gvEscalations";
                    gvEscalations.AutoGenerateColumns = true;
                    //gvPrimaryKPI.EmptyDataTemplate =  "No data found matching this set of parameters " + ForEmpID + StartDate.Month.ToString("M");

                    DataRow dr = dt.NewRow();

                    gvEscalations.DataSource = dt;
                    gvEscalations.CssClass = "table DataTable table-condensed table-bordered table-responsive";
                    gvEscalations.DataBind();
                    if (dt.Rows.Count > 0)
                    {
                        gvEscalations.Rows[gvEscalations.Rows.Count - 1].CssClass = "text-muted well well-sm no-shadow";
                        gvEscalations.Rows[gvEscalations.Rows.Count - 1].Font.Bold = true;
                        gvEscalations.PreRender += gv_PreRender;
                    }


                    pnlEscalations.Controls.Add(gvEscalations);
                }
                else
                {
                    ltl_Escalations.Text = string.Empty;
                }
            }

        }

    }
    public void fillpnl_Forecasting_Accuracy(int ForEmpID)
    {
        string metric = "Forecastin_ Accuracy";
        if (IsManager == 1)
        {
            string strSQL1 = "[WFMPMS].[GetManagerKPI]";

            SqlCommand cmd1 = new SqlCommand(strSQL1);
            cmd1.CommandType = CommandType.StoredProcedure;
            cmd1.Parameters.AddWithValue("@EmpCode", ForEmpID);
            cmd1.Parameters.AddWithValue("@StartDate", StartDate);
            cmd1.Parameters.AddWithValue("@EndDate", EndDate);
            cmd1.Parameters.AddWithValue("@Metric", metric);

            DataTable dt1 = my.GetDataTableViaProcedure(ref cmd1);
            if (dt1 != null)
            {
                GridView gvForecastingAccuracy = new GridView();
                gvForecastingAccuracy.ID = "gvForecastingAccuracy";
                gvForecastingAccuracy.AutoGenerateColumns = true;
                //gvPrimaryKPI.EmptyDataTemplate =  "No data found matching this set of parameters " + ForEmpID + StartDate.Month.ToString("M");

                DataRow dr1 = dt1.NewRow();

                gvForecastingAccuracy.DataSource = dt1;
                gvForecastingAccuracy.CssClass = "table DataTable table-condensed table-bordered table-responsive";
                gvForecastingAccuracy.DataBind();
                if (dt1.Rows.Count > 0)
                {
                    gvForecastingAccuracy.Rows[gvForecastingAccuracy.Rows.Count - 1].CssClass = "text-muted well well-sm no-shadow";
                    gvForecastingAccuracy.Rows[gvForecastingAccuracy.Rows.Count - 1].Font.Bold = true;
                    gvForecastingAccuracy.PreRender += gv_PreRender;
                    //BTPRating = Convert.ToDecimal(dt1.Rows[dt1.Rows.Count - 1]["Metric_Score"].ToString());
                    bool farating = false;
                    decimal dec_farating;
                    farating = Decimal.TryParse(dt1.Rows[dt1.Rows.Count - 1]["Metric_Score"].ToString(), out dec_farating);
                    if (farating)
                    {
                        ForecastingAccuracy = dec_farating;
                    }
                    else
                    {
                        ForecastingAccuracy = 0;
                    }
                    ltl_Forecasting_Accuracy.Text = ForecastingAccuracy.ToString();
                    ltlForecasting_Accuracy.Text = "Forecasting Accuracy = ";
                    pnlForecasting_Accuracy.Controls.Add(gvForecastingAccuracy);
                }
            }
        }
        else
        {
            //WFMPMS.getForecastAccuracyScore
            string strSQL = "[WFMPMS].[IEXForecastingScore]";

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
                //gvPrimaryKPI.EmptyDataTemplate =  "No data found matching this set of parameters " + ForEmpID + StartDate.Month.ToString("M");

                DataRow dr = dt.NewRow();

                gvForecastingAccuracy.DataSource = dt;
                gvForecastingAccuracy.CssClass = "table DataTable table-condensed table-bordered table-responsive";
                gvForecastingAccuracy.DataBind();
                if (dt.Rows.Count > 0)
                {
                    gvForecastingAccuracy.Rows[gvForecastingAccuracy.Rows.Count - 1].CssClass = "text-muted well well-sm no-shadow";
                    gvForecastingAccuracy.Rows[gvForecastingAccuracy.Rows.Count - 1].Font.Bold = true;
                    gvForecastingAccuracy.PreRender += gv_PreRender;
                    //ForecastingAccuracy = Convert.ToDecimal(dt.Rows[dt.Rows.Count - 1]["Rating"].ToString());
                    bool farating = false;
                    decimal dec_farating;
                    farating = Decimal.TryParse(dt.Rows[dt.Rows.Count - 1]["Rating"].ToString(), out dec_farating);
                    if (farating)
                    {
                        ForecastingAccuracy = dec_farating;
                    }
                    else
                    {
                        ForecastingAccuracy = 0;
                    }

                    ltl_Forecasting_Accuracy.Text = ForecastingAccuracy.ToString();
                }


                pnlForecasting_Accuracy.Controls.Add(gvForecastingAccuracy);
            }
            else
            {
                ltl_Forecasting_Accuracy.Text = "Forecasting Accuracy &nbsp= &nbsp" + "No Data found";
            }
        }
    }
    public void fillpnl_Headcount_Accuracy(int ForEmpID)
    {
        string metric = "Headcount_Accuracy";
        if (IsManager == 1)
        {
            string strSQL1 = "[WFMPMS].[GetManagerKPI]";

            SqlCommand cmd1 = new SqlCommand(strSQL1);
            cmd1.CommandType = CommandType.StoredProcedure;
            cmd1.Parameters.AddWithValue("@EmpCode", ForEmpID);
            cmd1.Parameters.AddWithValue("@StartDate", StartDate);
            cmd1.Parameters.AddWithValue("@EndDate", EndDate);
            cmd1.Parameters.AddWithValue("@Metric", metric);

            DataTable dt1 = my.GetDataTableViaProcedure(ref cmd1);
            if (dt1 != null)
            {
                GridView gvHeadcountAccuracy = new GridView();
                gvHeadcountAccuracy.ID = "gvHeadcountAccuracy";
                gvHeadcountAccuracy.AutoGenerateColumns = true;
                //gvPrimaryKPI.EmptyDataTemplate =  "No data found matching this set of parameters " + ForEmpID + StartDate.Month.ToString("M");

                DataRow dr1 = dt1.NewRow();

                gvHeadcountAccuracy.DataSource = dt1;
                gvHeadcountAccuracy.CssClass = "table DataTable table-condensed table-bordered table-responsive";
                gvHeadcountAccuracy.DataBind();
                if (dt1.Rows.Count > 0)
                {
                    gvHeadcountAccuracy.Rows[gvHeadcountAccuracy.Rows.Count - 1].CssClass = "text-muted well well-sm no-shadow";
                    gvHeadcountAccuracy.Rows[gvHeadcountAccuracy.Rows.Count - 1].Font.Bold = true;
                    gvHeadcountAccuracy.PreRender += gv_PreRender;
                    //BTPRating = Convert.ToDecimal(dt1.Rows[dt1.Rows.Count - 1]["Metric_Score"].ToString());
                    bool hcarating = false;
                    decimal dec_hcarating;
                    hcarating = Decimal.TryParse(dt1.Rows[dt1.Rows.Count - 1]["Metric_Score"].ToString(), out dec_hcarating);
                    if (hcarating)
                    {
                        HeadcountAccuracy = dec_hcarating;
                    }
                    else
                    {
                        HeadcountAccuracy = 0;
                    }
                    ltl_Headcount_Accuracy.Text = HeadcountAccuracy.ToString();
                    ltlHeadcount_Accuracy.Text = "Headcount Accuracy = ";
                    //pnlHeadcount_Accuracy.Controls.Add(gvHeadcountAccuracy);
                }


                pnlHeadcount_Accuracy.Controls.Add(gvHeadcountAccuracy);
            }
        }
        else
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
                //gvPrimaryKPI.EmptyDataTemplate =  "No data found matching this set of parameters " + ForEmpID + StartDate.Month.ToString("M");

                DataRow dr = dt.NewRow();

                gvHeadcountAccuracy.DataSource = dt;
                gvHeadcountAccuracy.CssClass = "table DataTable table-condensed table-bordered table-responsive";
                gvHeadcountAccuracy.DataBind();
                if (dt.Rows.Count > 0)
                {
                    gvHeadcountAccuracy.Rows[gvHeadcountAccuracy.Rows.Count - 1].CssClass = "text-muted well well-sm no-shadow";
                    gvHeadcountAccuracy.Rows[gvHeadcountAccuracy.Rows.Count - 1].Font.Bold = true;
                    gvHeadcountAccuracy.PreRender += gv_PreRender;
                    bool hcarating = false;
                    decimal dec_hcarating;
                    hcarating = Decimal.TryParse(dt.Rows[dt.Rows.Count - 1]["Rating"].ToString(), out dec_hcarating);
                    if (hcarating)
                    {
                        HeadcountAccuracy = dec_hcarating;
                    }
                    else
                    {
                        HeadcountAccuracy = 0;
                    }
                    ltl_Headcount_Accuracy.Text = HeadcountAccuracy.ToString();
                    ltlHeadcount_Accuracy.Text = "Headcount Accuracy = ";
                }


                pnlHeadcount_Accuracy.Controls.Add(gvHeadcountAccuracy);
            }
            else
            {
                ltlHeadcount_Accuracy.Text = "Headcount Accuracy &nbsp= &nbsp" + "No Data found";
            }
        }
    }
    #endregion
    #region RTA
    public void fillpnl_Real_Time_Optimization(int ForEmpID)
    {
        /*
         * 0. Am I a manager or not. If so, WFMPMS.GetManagerKPI gets my rating directly.
         * 1. Get a list of my accounts.
         * 2. For these accounts what skillsets do i profess.
         * 3. If I am assigned more than 1 distinct skillsets (Planning, Scheduling or RTA) I'm out of scope.
         * 4. If I have one and only one distinct skillset assigned for all accounts I can proceed further.
         * 5. If my skillset is RTA, For each individual KPI run the WFMPMS.get<KPI>SummaryForPACMAN procedure exactly once.
         * 6. Merge the above datatables into one. Calculate the merged score as my Primary KPI Score.
         * 7. If I profess the planning or scheduling skillset, then just run the WFMPMS.getSLSummaryForPACMAN
         * contd. because that procedure contains the intelligence needed to pull data from KPI dashboard 
         * contd. for that month for all Accounts and KPIs.
        */
        string metric = "Real Time Optimization";
        fillStartAndEndDates();
        if (IsManager == 1)
        {
            string strSQL1 = "[WFMPMS].[GetManagerKPI]";

            SqlCommand cmd1 = new SqlCommand(strSQL1);
            cmd1.CommandType = CommandType.StoredProcedure;
            cmd1.Parameters.AddWithValue("@EmpCode", ForEmpID);
            cmd1.Parameters.AddWithValue("@StartDate", StartDate);
            cmd1.Parameters.AddWithValue("@EndDate", EndDate);
            cmd1.Parameters.AddWithValue("@Metric", metric);

            DataTable dt1 = my.GetDataTableViaProcedure(ref cmd1);
            if (dt1 != null)
            {
                GridView gvOptimizationKPI = new GridView();
                gvOptimizationKPI.ID = "gvOptimizationKPI";
                gvOptimizationKPI.AutoGenerateColumns = true;
                //gvPrimaryKPI.EmptyDataTemplate =  "No data found matching this set of parameters " + ForEmpID + StartDate.Month.ToString("M");

                DataRow dr1 = dt1.NewRow();

                gvOptimizationKPI.DataSource = dt1;
                gvOptimizationKPI.CssClass = "table DataTable table-condensed table-bordered table-responsive";
                gvOptimizationKPI.DataBind();
                if (dt1.Rows.Count > 0)
                {
                    gvOptimizationKPI.Rows[gvOptimizationKPI.Rows.Count - 1].CssClass = "text-muted well well-sm no-shadow";
                    gvOptimizationKPI.Rows[gvOptimizationKPI.Rows.Count - 1].Font.Bold = true;
                    gvOptimizationKPI.PreRender += gv_PreRender;
                    OptimizationRating = Convert.ToDecimal(dt1.Rows[dt1.Rows.Count - 1]["Metric_Score"].ToString());
                    ltlOptimization.Text = "Real Time Optimization &nbsp= &nbsp";
                    ltl_Real_Time_Optimization.Text = OptimizationRating.ToString();
                    pnlOptimization.Controls.Add(gvOptimizationKPI);
                }
            }
        }
        else if (IsManager == 0)
        {
            fillStartAndEndDates();
            //* 1. Get a list of my accounts.
            DtOfAccountsIHandle = getDtOfAccountsIHandle(ForEmpID);

            //* 2. For these accounts what skillsets do i profess.
            var myPrimaryKPIs = DtOfAccountsIHandle.AsEnumerable()
                .Where(s => s.Field<string>("PrimaryKPI") != null)
                .Select(s => new { kpi = s.Field<string>("PrimaryKPI") })
                .Distinct();

            //3.If I am assigned more than 1 distinct skillsets(Planning, Scheduling or RTA) I'm out of scope.
            var mySkillsets = DtOfAccountsIHandle.AsEnumerable()
                .Select(t => t.Field<int>("SkillsetId")).Distinct();
            //*4.If I have one and only one distinct skillset assigned for all accounts I can proceed further.
            if (mySkillsets.Count() == 1)
            {
                //string strSQL = "WFMPMS.getSLOptimizationSummaryForPACMAN";
                SqlCommand cmd = new SqlCommand();
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@EmpCode", ForEmpID);
                fillStartAndEndDates();
                cmd.Parameters.AddWithValue("@StartDate", StartDate);
                cmd.Parameters.AddWithValue("@EndDate", EndDate);
                DataTable dt = new DataTable();
                if (mySkillsets.FirstOrDefault() == 2 || mySkillsets.FirstOrDefault() == 3)
                {
                    cmd.CommandText = "WFMPMS.getSLOptimizationSummaryForPACMAN";
                    dt = my.GetDataTableViaProcedure(ref cmd);
                }
                else if (mySkillsets.FirstOrDefault() == 4)
                {
                    int i = 0;
                    fillStartAndEndDates();
                    foreach (var individualKPI in myPrimaryKPIs)
                    {
                        cmd.CommandText = "WFMPMS.get" + individualKPI.kpi.ToString() + "OptimizationSummaryForPACMAN";

                        if (i == 0)
                        {
                            dt = my.GetDataTableViaProcedure(ref cmd);
                            dt.Columns["PrimaryKPI"].AllowDBNull = true;
                            dt.Columns["AccountId"].AllowDBNull = true;
                            dt.Columns["Rating"].AllowDBNull = true;
                            dt.Columns["Occurence"].AllowDBNull = true;
                            dt.Columns["RatingxOccurence"].AllowDBNull = true;
                            dt.Columns["Calculation"].AllowDBNull = true;
                            dt.Columns["PrimaryKPI"].MaxLength = 500;
                            i++;
                        }
                        else
                        {
                            DataTable dttemp = new DataTable();
                            dttemp = my.GetDataTableViaProcedure(ref cmd);

                            foreach (DataRow r in dttemp.Rows)
                            {
                                KPISummary j = new KPISummary();
                                j.AccountId = r["AccountId"].ToString();
                                j.Account = r["Account"].ToString();
                                j.PrimaryKPI = r["PrimaryKPI"].ToString();
                                j.PrimaryKPITarget = Convert.ToDecimal(r["PrimaryKPITarget"].ToString());
                                if (r["Rating"].ToString() == "")
                                { j.Rating = 0; }
                                else
                                {
                                    j.Rating = Convert.ToDecimal(r["Rating"].ToString());
                                }
                                if (r["RatingxOccurence"].ToString() == "")
                                {
                                    j.RatingxOccurence = 0;
                                }
                                else
                                {
                                    j.RatingxOccurence = Convert.ToInt32(r["RatingxOccurence"].ToString());
                                }

                                DataRow k = dt.NewRow();
                                k["AccountId"] = j.AccountId;
                                k["Account"] = j.Account;
                                k["PrimaryKPI"] = j.PrimaryKPI;
                                k["PrimaryKPITarget"] = j.PrimaryKPITarget;
                                k["Rating"] = j.Rating;
                                k["Occurence"] = j.Occurence;
                                k["RatingxOccurence"] = j.RatingxOccurence;
                                k["Calculation"] = j.Calculation;
                                dt.Rows.Add(k);


                            }
                            dttemp.Clear();
                            i++;
                        }
                    }
                    dt = ConsolidateDataTables(ref dt);
                    if (dt != null && dt.Rows.Count > 0)
                    {
                        GridView gvOptimizationKPI = new GridView();
                        gvOptimizationKPI.AutoGenerateColumns = true;

                        gvOptimizationKPI.DataSource = dt;
                        gvOptimizationKPI.DataBind();
                        gvOptimizationKPI.CssClass = "table DataTable table-condensed table-bordered table-responsive";
                        gvOptimizationKPI.Rows[gvOptimizationKPI.Rows.Count - 1].CssClass = "text-muted well well-sm no-shadow";
                        gvOptimizationKPI.Rows[gvOptimizationKPI.Rows.Count - 1].Font.Bold = true;

                        bool optirating = false;
                        decimal dec_optirating;
                        optirating = Decimal.TryParse(dt.Rows[dt.Rows.Count - 1]["Rating"].ToString(), out dec_optirating);
                        if (optirating)
                        {
                            OPRating += dec_optirating;
                        }
                        else
                        {
                            OPRating += 0;
                        }
                        ltlOptimization.Text = "Real Time Optimization &nbsp= &nbsp";
                        ltl_Real_Time_Optimization.Text = Math.Round(OPRating, 2).ToString();
                        pnlOptimization.Controls.Add(gvOptimizationKPI);

                        gvOptimizationKPI.PreRender += gv_PreRender;
                    }
                }
                else
                {
                    ltlOptimization.Text = "Multiple Roles found. The total KPI score for this employee will lead to an invalid condition (greater than 5)";
                    ltl_Real_Time_Optimization.Text = String.Empty;
                }
            }




        }


    }
    #endregion
    #region Scheduling
    public void fillpnl_Scheduling_Accuracy(int ForEmpID)
    {
        string metric = "Scheduling_Accuracy";
        if (IsManager == 1)
        {
            string strSQL1 = "[WFMPMS].[GetManagerKPI]";

            SqlCommand cmd1 = new SqlCommand(strSQL1);
            cmd1.CommandType = CommandType.StoredProcedure;
            cmd1.Parameters.AddWithValue("@EmpCode", ForEmpID);
            cmd1.Parameters.AddWithValue("@StartDate", StartDate);
            cmd1.Parameters.AddWithValue("@EndDate", EndDate);
            cmd1.Parameters.AddWithValue("@Metric", metric);

            DataTable dt1 = my.GetDataTableViaProcedure(ref cmd1);
            if (dt1 != null)
            {
                GridView gvSchedulingAccuracy = new GridView();
                gvSchedulingAccuracy.ID = "gvSchedulingAccuracy";
                gvSchedulingAccuracy.AutoGenerateColumns = true;
                //gvPrimaryKPI.EmptyDataTemplate =  "No data found matching this set of parameters " + ForEmpID + StartDate.Month.ToString("M");

                DataRow dr1 = dt1.NewRow();

                gvSchedulingAccuracy.DataSource = dt1;
                gvSchedulingAccuracy.CssClass = "table DataTable table-condensed table-bordered table-responsive";
                gvSchedulingAccuracy.DataBind();
                if (dt1.Rows.Count > 0)
                {
                    gvSchedulingAccuracy.Rows[gvSchedulingAccuracy.Rows.Count - 1].CssClass = "text-muted well well-sm no-shadow";
                    gvSchedulingAccuracy.Rows[gvSchedulingAccuracy.Rows.Count - 1].Font.Bold = true;
                    gvSchedulingAccuracy.PreRender += gv_PreRender;
                    SchedulingAccuracy = Convert.ToDecimal(dt1.Rows[dt1.Rows.Count - 1]["Metric_Score"].ToString());
                    ltlSchedulingAccuracy.Text = "Scheduling Accuracy = ";
                    ltl_Scheduling_Accuracy.Text = SchedulingAccuracy.ToString();
                    pnlSchedulingAccuracy.Controls.Add(gvSchedulingAccuracy);
                }
            }
        }
        else
        {
            //WFMPMS.getSchedulingAccuracyScore
            string strSQL = "[WFMPMS].[IEXSchedulingScore]";

            SqlCommand cmd = new SqlCommand(strSQL);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@EmpCode", ForEmpID);
            cmd.Parameters.AddWithValue("@StartDate", StartDate);
            cmd.Parameters.AddWithValue("@EndDate", EndDate);

            DataTable dt = my.GetDataTableViaProcedure(ref cmd);
            if (dt != null && dt.Rows.Count > 0)
            {
                GridView gvSchedulingAccuracy = new GridView();
                gvSchedulingAccuracy.ID = "gvSchedulingAccuracy";
                gvSchedulingAccuracy.AutoGenerateColumns = true;
                //gvPrimaryKPI.EmptyDataTemplate =  "No data found matching this set of parameters " + ForEmpID + StartDate.Month.ToString("M");

                DataRow dr = dt.NewRow();

                gvSchedulingAccuracy.DataSource = dt;
                gvSchedulingAccuracy.CssClass = "table DataTable table-condensed table-bordered table-responsive";
                gvSchedulingAccuracy.DataBind();


                gvSchedulingAccuracy.Rows[gvSchedulingAccuracy.Rows.Count - 1].CssClass = "text-muted well well-sm no-shadow";
                gvSchedulingAccuracy.Rows[gvSchedulingAccuracy.Rows.Count - 1].Font.Bold = true;
                gvSchedulingAccuracy.PreRender += gv_PreRender;
                SchedulingAccuracy = Convert.ToDecimal(dt.Rows[dt.Rows.Count - 1]["Rating"].ToString());
                ltl_Scheduling_Accuracy.Text = SchedulingAccuracy.ToString();

                pnlSchedulingAccuracy.Controls.Add(gvSchedulingAccuracy);
            }
            else
            {
                ltlSchedulingAccuracy.Text = "Scheduling Accuracy : ";
                ltl_Scheduling_Accuracy.Text = "0";

            }
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
                cmd.Parameters.AddWithValue("@PeriodID", PeriodID);
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
    //export function
    protected void btnDownload_Click(object sender, EventArgs e)
    {
        LinkButton b = sender as LinkButton;
        string Metric = b.ID.ToString().Replace("btn", "");
        PeriodID = Convert.ToInt32(ddlReviewPeriod.SelectedValue);
        string strSQL = "SELECT [FromDate],[ToDate] FROM [CWFM_Umang].[WFMPMS].[tblPacmanCycle] where [ID] =" + PeriodID;
        DataTable dt = my.GetData(strSQL);
        ForEmpID = Convert.ToInt32(ddlReportee.SelectedItem.Value.ToString());
        StartDate = Convert.ToDateTime(dt.Rows[0]["FromDate"].ToString());
        EndDate = Convert.ToDateTime(dt.Rows[0]["ToDate"].ToString());
        string metric2Download;
        SqlCommand cmd = new SqlCommand();
        cmd.Parameters.AddWithValue("@EmpCode", ForEmpID);
        cmd.Parameters.AddWithValue("@StartDate", StartDate);
        cmd.Parameters.AddWithValue("@EndDate", EndDate);
        int SelectedEmpIsManager = my.getSingleton("Select case when LevelID >80 then 0 else 1 end as isManager from WFMP.tblMaster where Employee_ID = " + ForEmpID);

        switch (Metric)
        {
            case "Absenteeism":
                strSQL = "WFMPMS.GetSelfAttendanceScore";
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@DownloadDetailedReport", 1);
                break;
            case "Accuracy":
                strSQL = "WFMPMS.GetAnalyticAccuracyScore";
                cmd.CommandType = CommandType.StoredProcedure;
                break;
            case "Attrition":
                if (SelectedEmpIsManager == 1)
                {
                    strSQL = "wfmpms.getAttritionDetail";
                    cmd.CommandType = CommandType.StoredProcedure;
                }
                break;
            case "BTP":
                metric2Download = "BTP";
                if (SelectedEmpIsManager == 1)
                {
                    strSQL = "wfmpms.getmanagerdownload";
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@metric", metric2Download);
                }
                else
                {
                    strSQL = @"SELECT Distinct [AccountID],[Project],[Month],[ActualBTP],[TargetBTP]
                    ,[BTPAccuracy],[Criteria],[LowerTgt],[UpperTgt],[Rating],0 [Id],[EmpCode],[Name]
                    ,[SkillsetId],[Skillset],[PrimaryClientID],[Account],0 [Code_A],[FromDate],[ToDate]
                    ,[Active] FROM [WFMPMS].[tblBTPResults] A 
                    inner join WFMPMS.tblEmp2Account B on A.AccountID = B.PrimaryClientID 
                    and B.EmpCode = @EmpCode where convert(date,[Month]) = DATEADD(M,-1,@StartDate)";
                }
                break;

            case "Coaching_and_Feedback":
                strSQL = "WFMPMS.getAnalyticCoachingScore";
                cmd.CommandType = CommandType.StoredProcedure;
                break;
            case "Escalations":
                strSQL = "select A.ID, A.EmpCode, A.Type, A.Category, Description, ActionBy as UpdatedBy ";
                strSQL += ", ActionOn as UpdatedOn, Wtg, C.FromDate, C.ToDate ";
                strSQL += " from WFMPMS.TBLEI A left join WFMPMS.TBLEIWTG B on A.Category = B.Category and A.Type = B.Type ";
                strSQL += " inner join[WFMPMS].[tblPacmanCycle] C on A.PacmanCycle = C.Id ";
                strSQL += " where A.EmpCode=@EmpCode and A.active = 1 and B.Active = 1 ";
                strSQL += " and @StartDate between C.FromDate and C.ToDate";
                break;
            case "Forecasting_Accuracy":
                metric2Download = "Forecasting_Accuracy";
                if (SelectedEmpIsManager == 1)
                {
                    strSQL = "wfmpms.getmanagerdownload";
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@metric", metric2Download);
                }
                else
                {
                    strSQL = "SELECT* FROM [CWFM_Umang].[WFMPMS].[tblIEXForecastingResult] where [Employee_ID] = @EmpCode and [Date] between @StartDate and @EndDate";
                }
                break;
            case "Headcount_Accuracy":
                metric2Download = "Headcount_Accuracy";
                if (SelectedEmpIsManager == 1)
                {
                    strSQL = "wfmpms.getmanagerdownload";
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@metric", metric2Download);
                }
                else
                {
                    strSQL = "SELECT* FROM [WFMPMS].[tblHeadcountAccuracyResult] where [PlannerEmpCode] = @EmpCode and [Month] between @StartDate and @EndDate";
                }

                break;
            case "IEX_Management":
                strSQL = "WFMPMS.GetIEXMgmtScore";
                cmd.CommandType = CommandType.StoredProcedure;
                break;
            case "KPI":
                metric2Download = "KPI";
                if (SelectedEmpIsManager == 1)
                {
                    strSQL = "wfmpms.getmanagerdownload";
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@metric", metric2Download);
                }
                else if (SelectedEmpIsManager == 0)
                {

                    //* 1. Get a list of my accounts.
                    DtOfAccountsIHandle = getDtOfAccountsIHandle(ForEmpID);

                    //* 2. For these accounts what skillsets do i profess.
                    var myPrimaryKPIs = DtOfAccountsIHandle.AsEnumerable()
                        .Where(s => s.Field<string>("PrimaryKPI") != null)
                        .Select(s => new { kpi = s.Field<string>("PrimaryKPI") })
                        .Distinct();

                    //3.If I am assigned more than 1 distinct skillsets(Planning, Scheduling or RTA) I'm out of scope.
                    var mySkillsets = DtOfAccountsIHandle.AsEnumerable()
                        .Select(t => t.Field<int>("SkillsetId")).Distinct();

                    //*4.If I have one and only one distinct skillset assigned for all accounts I can proceed further.
                    if (mySkillsets.Count() == 1)
                    {
                        fillStartAndEndDates();
                        string tablename = string.Empty;
                        strSQL = string.Empty;
                        foreach (var individualKPI in myPrimaryKPIs)
                        {
                            tablename = "WFMPMS.tbl" + individualKPI.kpi.ToString() + "Results";
                            strSQL += "SELECT * FROM " + tablename + " where [Employee_ID] = @EmpCode and [Date] between @StartDate and @EndDate;";
                        }
                    }
                }
                break;
            case "On_Time_Delivery":
                strSQL = "WFMPMS.GetAnalyticTimelineScore";
                cmd.CommandType = CommandType.StoredProcedure;
                break;
            case "Projects":
                strSQL = "WFMPMS.getAnalyticProjectScore";
                cmd.CommandType = CommandType.StoredProcedure;
                break;
            case "Optimization":
                metric2Download = "Real Time Optimization";
                if (SelectedEmpIsManager == 1)
                {
                    strSQL = "wfmpms.getmanagerdownload";
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@metric", metric2Download);
                }
                else
                {
                    strSQL = "SELECT * FROM [WFMPMS].[tblSLOptimizationResults] where [Employee_ID] = @EmpCode and [Date] between @StartDate and @EndDate";
                }
                break;
            case "Revenue__Cost_optimization":
                // Manager KPIs
                break;
            case "Scheduling_Accuracy":
                metric2Download = "Scheduling_Accuracy";
                if (SelectedEmpIsManager == 1)
                {
                    strSQL = "wfmpms.getmanagerdownload";
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@metric", metric2Download);
                }
                else
                {
                    strSQL = "SELECT * FROM [CWFM_Umang].[WFMPMS].[tblIEXSchedulingResult] A where Employee_ID=@EmpCode and A.Date between @StartDate and @EndDate";

                }
                break;
            case "Self_Absenteeism":
                strSQL = "WFMPMS.GetSelfAttendanceScore";
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@DownloadDetailedReport", 1);
                break;

            case "Team_Absenteeism":
                metric2Download = "Absenteeism";
                if (SelectedEmpIsManager == 1)
                {
                    strSQL = "wfmpms.getmanagerdownload";
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@metric", metric2Download);
                }
                break;
            default:
                break;
        }
        fillStartAndEndDates();
        cmd.Parameters.AddWithValue("@EmpCode", ForEmpID);
        cmd.Parameters.AddWithValue("@StartDate", StartDate);
        cmd.Parameters.AddWithValue("@EndDate", EndDate);
        cmd.CommandText = strSQL;

        bool done = sendForDownload(Metric,ref cmd);
    }

    private bool sendForDownload(string Metric, ref SqlCommand cmd)
    {
        string MyName = my.getFirstResult("select dbo.getFullName(" + ForEmpID + ") as FullName");
        string FileName = MyName + "'s " + Metric + " for " + StartDate.ToString("MMM yyyy") + " downloaded " + DateTime.Now.ToString("dd-MMM-yyyy HH-mm-ss") + ".csv";
        cmd.Connection = new SqlConnection(my.getConnectionString());
        cmd.Connection.Open();
        SqlDataAdapter da = new SqlDataAdapter(cmd);
        DataSet ds = new DataSet("KPI_Downloads");
        da.Fill(ds);
        foreach(DataTable d in ds.Tables)
        {
            d.TableName = FileName;

            //Get the physical path to the file.
            string FilePath = Server.MapPath("Sitel//metric_downloads//" + FileName);
            using (var textWriter = File.CreateText(FilePath))
            {
                using (var csv = new CsvWriter(textWriter))
                {
                    // Write columns
                    foreach (DataColumn column in d.Columns)
                    {
                        csv.WriteField(column.ColumnName);
                    }
                    csv.NextRecord();

                    // Write row values
                    foreach (DataRow row in d.Rows)
                    {
                        for (var i = 0; i < d.Columns.Count; i++)
                        {
                            csv.WriteField(row[i]);
                        }
                        csv.NextRecord();
                    }
                }
            }

            //Send the CSV file as a Download.
            Response.Clear();
            Response.Buffer = true;
            Response.AddHeader("content-disposition", "attachment;filename=" + FileName);
            Response.Charset = "";
            Response.ContentType = "application/text";
            Response.Output.Write(File.ReadAllText(FilePath));
            Response.Flush();
            Response.End();
        }
        return true;
    }

    protected void btnRevenue_and_Cost_optimization_Click(object sender, EventArgs e)
    {
        SqlConnection con = new SqlConnection(my.getConnectionString());
        con.Open();

        String strSQL = "[WFMPMS].[InsertRevenueScore]";
        SqlCommand cmd = new SqlCommand(strSQL, con);
        cmd.CommandType = CommandType.StoredProcedure;
        PeriodID = Convert.ToInt32(ddlReviewPeriod.SelectedItem.Value.ToString());
        int reportee = Convert.ToInt32(ddlReportee.SelectedItem.Value.ToString());
        int score = Convert.ToInt32(ddlRevenue_and_Cost_optimization.SelectedItem.Value.ToString());
        string comments = tbRevenue_and_Cost_optimization.Text.ToString();

        cmd.Parameters.AddWithValue("@PeriodID", PeriodID);
        cmd.Parameters.AddWithValue("@EmpCode", reportee);
        cmd.Parameters.AddWithValue("@Score", score);
        cmd.Parameters.AddWithValue("@Comments", comments);
        cmd.Parameters.AddWithValue("@ActionedBy", ForEmpID);
        cmd.Connection = con;
        cmd.ExecuteNonQuery();
        con.Close();
        //ltlRevenue_and_Cost_optimization1.Text = "Revenue_and_Cost_optimization &nbsp= &nbsp" + "<div class=\"pull-right header\">" + score + "</div>";
        ltl_Revenue_and_Cost_optimization.Text = score.ToString();
        clearRevenueScorefields();
    }
}