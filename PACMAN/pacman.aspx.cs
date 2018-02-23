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
using System.Linq.Expressions;
using System.IO;
using CsvHelper;

public partial class pacman : System.Web.UI.Page
{
    DataTable dtEmp;
    Helper my;
    private string strSQL { get; set; }
    private int MyEmpID { get; set; }
    private string MyName { get; set; }
    private int MyRepMgr { get; set; }
    private DateTime StartDate { get; set; }
    private DateTime EndDate { get; set; }
    private int PacmanCycle { get; set; }
    private decimal SLRating { get; set; }
    private decimal OptimizationRating { get; set; }
    private decimal EIRating { get; set; }
    private decimal AbsenteeismRating { get; set; }
    private decimal BTPRating { get; set; }
    public string lblPacmanCycle { get; set; }
    public DataTable DtOfAccountsIHandle { get; set; }
    private int IEXMgmt { get; set; }
    private int AnalyticProject { get; set; }
    private int AnalyticCoaching { get; set; }
    private int AnalyticTimeline { get; set; }
    private int Accuracy { get; set; }
    private int CurrentStage { get; set; }
    private int EachKPI_Score { get; set; }

    private decimal FinalRating { get; set; }
    private decimal SchedulingAccuracy { get; set; }
    private decimal ForecastingAccuracy { get; set; }
    private decimal HeadcountAccuracy { get; set; }

    private int CurrrentPacManCycle { get; set; }
    protected void Page_Load(object sender, EventArgs e)
    {
        my = new Helper();

        if (!IsPostBack)
        {
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
                    MyName = dtEmp.Rows[0]["First_Name"].ToString() + " " + dtEmp.Rows[0]["Middle_Name"].ToString() + " " + dtEmp.Rows[0]["Last_Name"].ToString();
                    MyRepMgr = Convert.ToInt32(dtEmp.Rows[0]["RepMgrCode"].ToString());
                }
            }
            catch (Exception Ex)
            {
                Console.WriteLine(Ex.Message.ToString());
                Response.Redirect(ViewState["PreviousPageUrl"] != null ? ViewState["PreviousPageUrl"].ToString() : "index.aspx", false);
            }
            Literal title = (Literal)PageExtensionMethods.FindControlRecursive(Master, "ltlPageTitle");
            title.Text = "PACMAN";
            fillddlReviewPeriod();
            enableDisableButtons();
            getNamePacmanCycle();
            //DtOfAccountsIHandle = getDtOfAccountsIHandle();
            showRelevantMetricPanels(MyEmpID);


        }
        else
        {
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
                    MyRepMgr = Convert.ToInt32(dtEmp.Rows[0]["RepMgrCode"].ToString());
                }
            }
            catch (Exception Ex)
            {
                Console.WriteLine(Ex.Message.ToString());
                Response.Redirect(ViewState["PreviousPageUrl"] != null ? ViewState["PreviousPageUrl"].ToString() : "index.aspx", false);
            }
        }

    }
    private DataTable getDtOfAccountsIHandle()
    {
        string strSQL = "WFMPMS.GetAllAccountsIHandle";
        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.Parameters.AddWithValue("@Employee_ID", MyEmpID);


        DataTable dt = my.GetDataTableViaProcedure(ref cmd);


        gvAllMyAccounts.DataSource = dt;
        gvAllMyAccounts.DataBind();
        return dt;
    }
    public void fillpnl_KPI(int ForEmpID)
    {
        DtOfAccountsIHandle = getDtOfAccountsIHandle();
        fillStartAndEndDates();
        var myPrimaryKPIs = DtOfAccountsIHandle.AsEnumerable().Select(s => new { kpi = s.Field<string>("PrimaryKPI") }).Distinct().ToList();
        ltl_KPI.Text = String.Empty;
        DataSet dsKPIs = new DataSet();

        using (SqlConnection cn = new SqlConnection(my.getConnectionString()))
        {
            cn.Open();
            using (SqlCommand cmd = new SqlCommand(strSQL, cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@EmpCode", ForEmpID);
                cmd.Parameters.AddWithValue("@StartDate", StartDate);
                cmd.Parameters.AddWithValue("@EndDate", EndDate);

                foreach (var individualKPI in myPrimaryKPIs)
                {
                    cmd.CommandText = "WFMPMS.get" + individualKPI.kpi.ToString() + "SummaryForPACMAN";


                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();

                        cmd.ExecuteNonQuery();
                        da.Fill(dt);
                        if (dt != null)
                        {
                            GridView gvPrimaryKPI = new GridView();
                            gvPrimaryKPI.ID = "gv" + individualKPI.kpi;
                            gvPrimaryKPI.AutoGenerateColumns = true;
                            //gvPrimaryKPI.EmptyDataTemplate =  "No data found matching this set of parameters " + MyEmpID + StartDate.Month.ToString("M");

                            gvPrimaryKPI.DataSource = dt;
                            gvPrimaryKPI.CssClass = "table DataTable table-condensed table-bordered table-responsive";

                            gvPrimaryKPI.DataBind();
                            if (dt.Rows.Count > 0)
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
                                ltl_KPI.Text = SLRating.ToString();
                                pnlKPI.Controls.Add(gvPrimaryKPI);
                            }
                            else
                            {
                                ltlPrimaryKPI.Text = "Primary KPI &nbsp= &nbsp";// + "No Data found";
                                
                            }

                        }
                        else
                        {
                            ltlPrimaryKPI.Text = "Primary KPI &nbsp= &nbsp";// + "No Data found";
                            ltl_KPI.Text = String.Empty;
                        }

                    }
                }
            }
        }
    }

    private void showRelevantMetricPanels(int ForEmpID)
    {

        fillStartAndEndDates();
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
    private void fillRelevantMetricsInPanels(int ForEmpID)
    {
        fillStartAndEndDates();
        string strSQL = "SELECT Distinct B.id, B.Metrics FROM [CWFM_Umang].[WFMPMS].[tblEmp2Account] A  ";
        strSQL += " inner join [WFMPMS].[tblDsgn2KPIWtg] B on B.SkillsetId = A.SkillsetId  ";
        strSQL += " where EmpCode =  " + ForEmpID + " and [Active] = 1 and '" + StartDate + "' between A.FromDate and A.ToDate ";
        strSQL += " order by B.id, B.Metrics ";

        DataTable dt = my.GetData(strSQL);
        string myPanelName = string.Empty;

        foreach (DataRow d in dt.Rows)
        {
            // For Troubleshooting : Paras - Please remove when not needed.
            //if (d["Metrics"].ToString().Replace("&", "").Replace(" ", "_") == "BTP")
            //{
            myPanelName = "pnl_" + d["Metrics"].ToString().Replace("&", "").Replace(" ", "_");
            Control c = Page.FindControlRecursive(myPanelName);
            if (c != null)
            {
                Panel thePanel = c as Panel;
                thePanel.Visible = true;
                Type thisType = this.GetType();
                MethodInfo theMethod = thisType.GetMethod("fill" + myPanelName);
                try
                {
                    theMethod.Invoke(this, new object[] { MyEmpID });
                }
                catch (Exception Ex)
                {
                    Response.Write(Ex.Message.ToString());
                }
                finally
                {
                    my.close_conn();
                }
            }
        }        
    }
    private void getNamePacmanCycle()
    {
        //lblPC.Text = ddlReviewPeriod.SelectedItem.Text.ToString();
        string Name;
        strSQL = "[WFMPMS].[GetName]";
        using (SqlConnection cn = new SqlConnection(my.getConnectionString()))
        {
            cn.Open();
            using (SqlCommand cmd = new SqlCommand(strSQL, cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@EmpCode", MyEmpID);
                Name = cmd.ExecuteScalar().ToString();
            }
        }
        //lblName.Text = Name;
    }
    private void enableDisableButtons()
    {
        //int CurrentStage;
        PacmanCycle = Convert.ToInt32(ddlReviewPeriod.SelectedValue);
        strSQL = "[WFMPMS].[GetPacmanStage]";
        using (SqlConnection cn = new SqlConnection(my.getConnectionString()))
        {
            cn.Open();
            using (SqlCommand cmd = new SqlCommand(strSQL, cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@EmpCode", MyEmpID);
                cmd.Parameters.AddWithValue("@PacmanCycle", PacmanCycle);
                //CurrentStage = Convert.ToInt32(cmd.ExecuteScalar());
                //CurrentStage = 4;
                if (CurrentStage == 0 || CurrentStage == 2 || CurrentStage == 5)
                {
                    //btnYesDiscussed.Enabled = false;
                    //btnNotDiscussed.Enabled = false;
                    btnAgree.Enabled = false;
                    // Please remove the below true in production..........
                    //btnAgree.Enabled = true;
                }
                else if (CurrentStage == 3)
                {
                    //btnYesDiscussed.Enabled = true;
                    //btnNotDiscussed.Enabled = true;
                    btnAgree.Enabled = true;
                }
                else if (CurrentStage == 4)
                {
                    //btnYesDiscussed.Enabled = false;
                    //btnNotDiscussed.Enabled = false;
                    btnAgree.Enabled = true;
                }
            }

        }
    }
    private void fillddlReviewPeriod()
    {
        string strSQL = "WFMPMS.fillPacmanCycleSelectionDropdownList";
        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.Parameters.AddWithValue("@EmpCode", MyEmpID);
        DataTable dt = my.GetDataTableViaProcedure(ref cmd);

        ddlReviewPeriod.DataSource = dt;

        ddlReviewPeriod.DataTextField = "TextDescription";
        ddlReviewPeriod.DataValueField = "Id";
        ddlReviewPeriod.DataBind();
        //ddlReviewPeriod.Items.Add(new ListItem("----Select-----", "0"));

        ddlReviewPeriod.SelectedIndex = 0;

    }
    private void fillddlReviewPeriodOnPageLoad()
    {
        ddlReviewPeriod.SelectedValue = CurrrentPacManCycle.ToString();
        ddlReviewPeriod_SelectedIndexChanged(this, new EventArgs());
    }
    protected void ddlReviewPeriod_SelectedIndexChanged(object sender, EventArgs e)
    {
        fillStartAndEndDates();
        fillRelevantMetricsInPanels(MyEmpID);
        enableDisableButtons();
        getFinalRating(MyEmpID);


    }

    private void fillStartAndEndDates()
    {
        PacmanCycle = Convert.ToInt32(ddlReviewPeriod.SelectedValue);
        string strSQL = "SELECT [FromDate],[ToDate] FROM [CWFM_Umang].[WFMPMS].[tblPacmanCycle] where [ID] =" + PacmanCycle;
        DataTable dt = my.GetData(strSQL);
        if (dt != null && dt.Rows.Count > 0)
        {
            StartDate = Convert.ToDateTime(dt.Rows[0]["FromDate"].ToString());
            EndDate = Convert.ToDateTime(dt.Rows[0]["ToDate"].ToString());
        }
        else
        {
            StartDate = new DateTime(DateTime.Today.Year, 1, 1);
            EndDate = new DateTime(DateTime.Today.Year, 1, 31);
        }

    }

    //protected void btnYesDiscussed_Click(object sender, EventArgs e)
    //{
    //    btnAgree.Enabled = true;
    //    btnYesDiscussed.Enabled = false;
    //    btnNotDiscussed.Enabled = false;

    //    SqlConnection con = new SqlConnection(my.getConnectionString());
    //    con.Open();

    //    String strSQL = "[WFMPMS].[InsertPacmanStage]";
    //    SqlCommand cmd = new SqlCommand(strSQL, con);
    //    cmd.CommandType = CommandType.StoredProcedure;

    //    MyEmpID = Convert.ToInt32(dtEmp.Rows[0]["Employee_Id"].ToString());
    //    int Stage = 4;
    //    int PreviousStage = 3;
    //    PacmanCycle = Convert.ToInt32(ddlReviewPeriod.SelectedItem.Value.ToString());
    //    cmd.Parameters.AddWithValue("@EmpCode", MyEmpID);
    //    cmd.Parameters.AddWithValue("@Stage", Stage);
    //    cmd.Parameters.AddWithValue("@PacmanCycle", PacmanCycle);
    //    cmd.Parameters.AddWithValue("@ActionBy", MyEmpID);
    //    cmd.Parameters.AddWithValue("@PreviousStage", PreviousStage);

    //    cmd.Connection = con;
    //    cmd.ExecuteNonQuery();
    //    con.Close();
    //    //enableDisableButtons();
    //}

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
                ltl.Text = (ltl.Text == "") ? "0" : ltl.Text;
                Decimal KPIScore = Convert.ToDecimal(ltl.Text);
                FinalRating = FinalRating + (KPIScore * KPIWt);
            }
        }
        if (CurrentStage == 4)
        {
            ltlfinalScore.Text = "3";
            EachKPI_Score = 3;
        }

        else
        { ltlfinalScore.Text = FinalRating.ToString(); }

    }
    protected void btnAgree_Click(object sender, EventArgs e)
    {
        //btnYesDiscussed.Enabled = false;
        //btnNotDiscussed.Enabled = false;
        btnAgree.Enabled = false;

        SqlConnection con = new SqlConnection(my.getConnectionString());
        con.Open();

        String strSQL = "[WFMPMS].[InsertPacmanStage]";
        SqlCommand cmd = new SqlCommand(strSQL, con);
        cmd.CommandType = CommandType.StoredProcedure;

        MyEmpID = Convert.ToInt32(dtEmp.Rows[0]["Employee_Id"].ToString());
        int Stage = 5;
        int PreviousStage = 3;
        PacmanCycle = Convert.ToInt32(ddlReviewPeriod.SelectedItem.Value.ToString());
        cmd.Parameters.AddWithValue("@EmpCode", MyEmpID);
        cmd.Parameters.AddWithValue("@Stage", Stage);
        cmd.Parameters.AddWithValue("@PacmanCycle", PacmanCycle);
        cmd.Parameters.AddWithValue("@ActionBy", MyEmpID);
        cmd.Parameters.AddWithValue("@PreviousStage", PreviousStage);

        cmd.Connection = con;
        cmd.ExecuteNonQuery();
        con.Close();
        InsertTotblFinalKPI(MyEmpID);
        enableDisableButtons();
    }
    private void InsertTotblFinalKPI(int ForEmpID)
    {
        //CurrentStage = 4;---------------------------------------check
        PacmanCycle = Convert.ToInt32(ddlReviewPeriod.SelectedValue);
        string strSQL = "SELECT [FromDate],[ToDate] FROM [CWFM_Umang].[WFMPMS].[tblPacmanCycle] where [ID] =" + PacmanCycle;
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
                if (CurrentStage == 4)
                { FinalRating = 3; }

                else
                { FinalRating = KPIScore * KPIWt; }

                SqlCommand cmd = new SqlCommand(strSQL);
                cmd.Parameters.AddWithValue("@EmpCode", ForEmpID);
                cmd.Parameters.AddWithValue("@PacmanCycle", PacmanCycle);
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





        //my.ExecuteDMLCommand(ref cmd, strSQL, "");

    }
    public void fillltlfinalScore(int ForEmpID)
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
                cmd.Parameters.AddWithValue("@PacmanCycle", PacmanCycle);
                SqlDataReader sdr = cmd.ExecuteReader();
                while (sdr.Read())
                {
                    if (sdr.HasRows)
                    {
                        //AnalyticCoaching = Convert.ToInt32(sdr.GetValue(0));
                        AnalyticCoaching = Convert.ToInt32(sdr.GetValue(0));
                        ltlCoachingFeedback.Text = "Coaching & Feedback &nbsp= &nbsp";
                        ltl_Coaching_and_Feedback.Text = AnalyticCoaching.ToString();
                    }
                    else
                    {
                        int noVal = 0;
                        ltlCoachingFeedback.Text = noVal.ToString();
                        ltl_Coaching_and_Feedback.Text = noVal.ToString();
                    }
                }
                //ltlCoachingFeedback.Text = "Coaching & Feedback &nbsp= &nbsp";
                //ltl_CoachingFeddback.Text = AnalyticCoaching.ToString();
            }

        }
    }
    public void fillpnl_On_Time_Delivery(int ForEmpID)
    {
        fillStartAndEndDates();
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
                        //if (val != null)
                        //    ltlOntimeDelivery.Text = "On Time Delivery &nbsp= &nbsp" + "<div class=\"pull-right header\">" + val + "</div>";
                        //else
                        //{
                        //    int noVal = 0;
                        //    ltlOntimeDelivery.Text = noVal.ToString();
                        //}

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
            gvAbsenteeism.Rows[gvAbsenteeism.Rows.Count - 1].CssClass = "text-muted well well-sm no-shadow";
            gvAbsenteeism.Rows[gvAbsenteeism.Rows.Count - 1].Font.Bold = true;
            gvAbsenteeism.PreRender += gv_PreRender;
            string absRating = dt.Rows[dt.Rows.Count - 1]["Rating"].ToString();
            Decimal dcAbsRting = 5;
            Decimal.TryParse(absRating, out dcAbsRting);
            AbsenteeismRating = dcAbsRting;
        }
        else
        {
            ltlBTP.Text = string.Empty;
        }
        ltlAbsenteeism.Text = "Self-Attendance &nbsp= &nbsp";
        pnlAbsenteeism.Controls.Add(gvAbsenteeism);
        ltl_Absenteeism.Text = AbsenteeismRating.ToString();
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
                    //if (sdr.HasRows)
                    //{
                    //    Accuracy = Convert.ToInt32(sdr.GetValue(0));
                    //    ltlAccuracy.Text = "Accuracy &nbsp= &nbsp" + "<div class=\"pull-right header\">" + Accuracy + "</div>";
                    //}
                    //else
                    //{
                    //    int noVal = 0;
                    //    ltlAccuracy.Text = noVal.ToString();
                    //}

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
                cmd.Parameters.AddWithValue("@PacmanCycle", PacmanCycle);
                SqlDataReader sdr = cmd.ExecuteReader();
                while (sdr.Read())
                {
                    //if (sdr.HasRows)
                    //{
                    //    AnalyticProject = Convert.ToInt32(sdr.GetValue(0));
                    //}

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
                //ltlAnalyticProject.Text = "Projects &nbsp= &nbsp" + "<div class=\"pull-right header\">" + AnalyticProject + "</div>";
                //ltlProject.Text = "Projects &nbsp= &nbsp";
                //ltl_Project.Text = AnalyticProject.ToString();
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
        PacmanCycle = Convert.ToInt32(ddlReviewPeriod.SelectedValue);
        string strSQL = "SELECT [FromDate],[ToDate] FROM [CWFM_Umang].[WFMPMS].[tblPacmanCycle] where [ID] =" + PacmanCycle;
        DataTable dt = my.GetData(strSQL);
        StartDate = Convert.ToDateTime(dt.Rows[0]["FromDate"].ToString());


        strSQL = "[WFMPMS].GetBTPByEmp";
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

        gvBTP.DataBind();
        if (dt != null && dt.Rows.Count > 0)
        {
            gvBTP.Rows[gvBTP.Rows.Count - 1].CssClass = "text-muted well well-sm no-shadow";
            gvBTP.Rows[gvBTP.Rows.Count - 1].Font.Bold = true;
            gvBTP.PreRender += gv_PreRender;
            BTPRating = Convert.ToDecimal(dt.Rows[dt.Rows.Count - 1]["Rating"].ToString());
        }
        else
        {
            ltlBTP.Text = string.Empty;
        }
        ltlBTP.Text = "BTP : Billed To Pay Ratio = ";
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
                    //gvPrimaryKPI.EmptyDataTemplate =  "No data found matching this set of parameters " + MyEmpID + StartDate.Month.ToString("M");

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

        //string strSQL = "WFMPMS.getSLOptimizationSummaryForPACMAN";

        //SqlCommand cmd = new SqlCommand(strSQL);
        //cmd.Parameters.AddWithValue("@EmpCode", ForEmpID);
        //cmd.Parameters.AddWithValue("@StartDate", StartDate);
        //cmd.Parameters.AddWithValue("@EndDate", EndDate);

        //DataTable dt = my.GetDataTableViaProcedure(ref cmd);
        //if (dt != null && dt.Rows.Count > 0)
        //{
        //    GridView gvOptimizationKPI = new GridView();
        //    gvOptimizationKPI.AutoGenerateColumns = true;

        //    gvOptimizationKPI.DataSource = dt;
        //    gvOptimizationKPI.DataBind();
        //    gvOptimizationKPI.CssClass = "table DataTable table-condensed table-bordered table-responsive";
        //    gvOptimizationKPI.Rows[gvOptimizationKPI.Rows.Count - 1].CssClass = "text-muted well well-sm no-shadow";
        //    gvOptimizationKPI.Rows[gvOptimizationKPI.Rows.Count - 1].Font.Bold = true;
        //    OptimizationRating = Convert.ToDecimal(dt.Rows[dt.Rows.Count - 1]["Rating"].ToString());
        //    ltlOptimization.Text = "Real Time Optimization &nbsp= &nbsp";
        //    ltl_Real_Time_Optimization.Text = OptimizationRating.ToString();
        //    pnlOptimization.Controls.Add(gvOptimizationKPI);

        //    gvOptimizationKPI.PreRender += gv_PreRender;
        //}
        //else
        //{
        //    ltlOptimization.Text = "Real Time Optimization &nbsp= &nbsp";
        //    ltl_Real_Time_Optimization.Text = String.Empty;
        //}


    }
    #endregion
    #region Scheduling
    public void fillpnl_Scheduling_Accuracy(int ForEmpID)
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
            //gvPrimaryKPI.EmptyDataTemplate =  "No data found matching this set of parameters " + MyEmpID + StartDate.Month.ToString("M");

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
            ltlSchedulingAccuracy.Text = "Scheduling Accuracy";
            ltl_Scheduling_Accuracy.Text = "0";

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



    protected void btnDownload_Click(object sender, EventArgs e)
    {
        LinkButton b = sender as LinkButton;
        string Metric = b.ID.ToString().Replace("btn", "");
        PacmanCycle = Convert.ToInt32(ddlReviewPeriod.SelectedValue);
        string strSQL = "SELECT [FromDate],[ToDate] FROM [CWFM_Umang].[WFMPMS].[tblPacmanCycle] where [ID] =" + PacmanCycle;
        DataTable dt = my.GetData(strSQL);
        StartDate = Convert.ToDateTime(dt.Rows[0]["FromDate"].ToString());
        EndDate = Convert.ToDateTime(dt.Rows[0]["ToDate"].ToString());

        SqlCommand cmd = new SqlCommand();
        cmd.Parameters.AddWithValue("@EmpCode", MyEmpID);
        cmd.Parameters.AddWithValue("@StartDate", StartDate);
        cmd.Parameters.AddWithValue("@EndDate", EndDate);

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
                // Manager KPIs
                break;
            case "BTP":
                strSQL = "SELECT Distinct * FROM [WFMPMS].[tblBTPResults] A inner join WFMPMS.tblEmp2Account B on A.AccountID = B.PrimaryClientID and B.EmpCode = @EmpCode where[Month] between DATEADD(M,-1,@StartDate) and DATEADD(M,-1,@EndDate)";
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
                strSQL = "SELECT* FROM [CWFM_Umang].[WFMPMS].[tblIEXForecastingResult] where [Employee_ID] = @EmpCode and [Date] between @StartDate and @EndDate";
                break;
            case "Headcount_Accuracy":
                strSQL = "SELECT* FROM [WFMPMS].[tblHeadcountAccuracyResult] where [PlannerEmpCode] = @EmpCode and [Month] between @StartDate and @EndDate";
                break;
            case "IEX_Management":
                strSQL = "SELECT EmpCode, Comments, ActionedBy, ActionedOn, Score as Rating, B.FromDate as StartDate, B.ToDate as EndDate ";
                strSQL += " FROM[CWFM_Umang].[WFMPMS].[tblIEXManagementScore] A inner join WFMPMs.tblPacmanCycle B on A.PacmanCycle = B.ID ";
                strSQL += " where[EmpCode] = @EmpCode and B.FromDate between @StartDate and @EndDate ";
                break;
            case "KPI":
                strSQL = "SELECT * FROM [WFMPMS].[tblKPIResults] where [Employee_ID] = @EmpCode and [Date] between @StartDate and @EndDate";
                break;
            case "On_Time_Delivery":
                strSQL = "WFMPMS.GetAnalyticTimelineScore";
                cmd.CommandType = CommandType.StoredProcedure;
                break;
            case "Projects":
                strSQL = "WFMPMS.getAnalyticProjectScore";
                cmd.CommandType = CommandType.StoredProcedure;
                break;
            case "Real_Time_Optimization":
                strSQL = "SELECT * FROM [WFMPMS].[tblSLOptimizationResults] where [Employee_ID] = @EmpCode and [Date] between @StartDate and @EndDate";
                break;
            case "Revenue__Cost_optimization":
                // Manager KPIs
                break;
            case "Scheduling_Accuracy":
                strSQL = "SELECT * FROM [CWFM_Umang].[WFMPMS].[tblIEXSchedulingResult] A where Employee_ID=@EmpCode and A.Date between @StartDate and @EndDate";
                break;
            case "Download":
                return;
                break;
            default:
                return;
                break;
        }

        cmd.CommandText = strSQL;
        cmd.Connection = new SqlConnection(my.getConnectionString());
        cmd.Connection.Open();


        //DataSet ds = new DataSet("Export_Details");
        //da.Fill(ds);
        Label MyName = (Label)PageExtensionMethods.FindControlRecursive(Master, "lblName");
        string FileName = MyName.Text + "'s " + Metric + " for " + StartDate.ToString("MMM yyyy") + " downloaded " + DateTime.Now.ToString("dd-MMM-yyyy HH-mm-ss") + ".csv";
        DataTable d = new DataTable(FileName);
        SqlDataAdapter da = new SqlDataAdapter(cmd);
        da.Fill(d);
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
}

