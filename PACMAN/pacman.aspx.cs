using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data.Sql;

public partial class pacman : System.Web.UI.Page
{
    DataTable dtEmp;
    Helper my;
    private string strSQL { get; set; }
    private int MyEmpID { get; set; }
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
    private decimal FinalRating { get; set; }

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
            DtOfAccountsIHandle = getDtOfAccountsIHandle();
            showRelevantMetrics();
            fillltlAccuracy(MyEmpID);
            fillltlAnalyticTimeline(MyEmpID);
            fillltlAnalyticCoaching(MyEmpID);
            fillltlAnalyticProject(MyEmpID);
            fillltlIEXMgmt(MyEmpID);
            fillltlfinalScore(MyEmpID);

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
        StartDate = DateTime.Today.Date;
        cmd.Parameters.AddWithValue("@StartDate", StartDate);

        DataTable dt = my.GetDataTableViaProcedure(ref cmd);
        //dt.DefaultView.RowFilter = "InBO=1";
        gvAllMyAccounts.DataSource = dt;
        gvAllMyAccounts.DataBind();

        return dt;


    }

    private void fillgvPrimaryKPI(int ForEmpID)
    {

        string strSQL = "WFMPMS.getSLSummaryForPACMAN";
        using (SqlConnection cn = new SqlConnection(my.getConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand(strSQL, cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@EmpCode", ForEmpID);
                cmd.Parameters.AddWithValue("@StartDate", StartDate);
                cmd.Parameters.AddWithValue("@EndDate", EndDate);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataSet ds = new DataSet();
                da.Fill(ds);
                DataTable dt = ds.Tables[0];
                if (dt.Rows.Count > 0)
                {
                    GridView gvPrimaryKPI = new GridView();
                    gvPrimaryKPI.ID = "gvPrimaryKPI";
                    gvPrimaryKPI.AutoGenerateColumns = true;
                    //gvPrimaryKPI.EmptyDataTemplate =  "No data found matching this set of parameters " + MyEmpID + StartDate.Month.ToString("M");


                    dt.Columns.Add("Calculation");
                    DataRow dr = dt.NewRow();

                    dt.ImportRow(ds.Tables[1].Rows[0]);
                    gvPrimaryKPI.DataSource = dt;
                    gvPrimaryKPI.CssClass = "table DataTable table-condensed table-bordered table-responsive";

                    gvPrimaryKPI.DataBind();
                    gvPrimaryKPI.Rows[gvPrimaryKPI.Rows.Count - 1].CssClass = "text-muted well well-sm no-shadow";
                    gvPrimaryKPI.Rows[gvPrimaryKPI.Rows.Count - 1].Font.Bold = true;
                    gvPrimaryKPI.PreRender += gv_PreRender;

                    SLRating = Convert.ToDecimal(ds.Tables[1].Rows[0]["Rating"].ToString());
                    ltlPrimaryKPI.Text = "Primary KPIname : Service Level &nbsp= &nbsp";
                    ltl_KPI.Text = SLRating.ToString();
                    pnlKPI.Controls.Add(gvPrimaryKPI);
                }
                else
                {
                    ltlPrimaryKPI.Text = "Primary KPIname : Service Level &nbsp= &nbsp" + "No Data found";
                }
            }

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

    private void showRelevantMetrics()
    {
        string strSQL = "SELECT Distinct B.id, B.Metrics FROM [CWFM_Umang].[WFMPMS].[tblEmp2Account] A  ";
        strSQL += " inner join [WFMPMS].[tblDsgn2KPIWtg] B on B.SkillsetId = A.SkillsetId  ";
        strSQL += " where EmpCode =  " + MyEmpID + " and [Active] = 1 and '" + StartDate + "' between A.FromDate and A.ToDate ";
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

    private void getNamePacmanCycle()
    {
        lblPC.Text = ddlReviewPeriod.SelectedItem.Text.ToString();
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
        lblName.Text = Name;
    }

    private void enableDisableButtons()
    {
        int CurrentStage;
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
                CurrentStage = Convert.ToInt32(cmd.ExecuteScalar());

                if (CurrentStage == 0 || CurrentStage == 2 || CurrentStage == 5)
                {
                    btnYesDiscussed.Enabled = false;
                    btnNotDiscussed.Enabled = false;
                    btnAgree.Enabled = false;
                }
                else if (CurrentStage == 3)
                {
                    btnYesDiscussed.Enabled = true;
                    btnNotDiscussed.Enabled = true;
                    btnAgree.Enabled = false;
                }
                else if (CurrentStage == 4)
                {
                    btnYesDiscussed.Enabled = false;
                    btnNotDiscussed.Enabled = false;
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
    }

    private void fillgvRealTimeOptimization(int ForEmpID)
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

    private void fillLtlEI(int ForEmpID)
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

    private void fillltlAbsenteeism(int ForEmpID)
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

    private void fillpnlBTP(string ForAccountId)
    {

        string strSQL = "WFMPMS.getBTPForAccount";

        SqlCommand cmd = new SqlCommand(strSQL);

        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@AccountId", ForAccountId);
        cmd.Parameters.AddWithValue("@Month", StartDate);

        DataTable dt = my.GetDataTableViaProcedure(ref cmd);

        GridView gvBTP = new GridView();
        gvBTP.ID = "gvBTP";
        gvBTP.AutoGenerateColumns = true;

        gvBTP.DataSource = dt;
        gvBTP.CssClass = "table DataTable table-condensed table-bordered table-responsive";

        gvBTP.DataBind();
        gvBTP.Rows[gvBTP.Rows.Count - 1].CssClass = "text-muted well well-sm no-shadow";
        gvBTP.Rows[gvBTP.Rows.Count - 1].Font.Bold = true;
        gvBTP.PreRender += gv_PreRender;

        BTPRating = Convert.ToDecimal(dt.Rows[0]["Rating"].ToString());
        ltlBTP.Text = "Billed To Pay &nbsp= &nbsp";
        pnlBTP.Controls.Add(gvBTP);
        ltl_BTP.Text = BTPRating.ToString();
    }

    protected void ddlReviewPeriod_SelectedIndexChanged(object sender, EventArgs e)
    {
        PacmanCycle = Convert.ToInt32(ddlReviewPeriod.SelectedValue);
        string strSQL = "SELECT [FromDate],[ToDate] FROM [CWFM_Umang].[WFMPMS].[tblPacmanCycle] where [ID] =" + PacmanCycle;
        DataTable dt = my.GetData(strSQL);
        StartDate = Convert.ToDateTime(dt.Rows[0]["FromDate"].ToString());
        EndDate = Convert.ToDateTime(dt.Rows[0]["ToDate"].ToString());

        fillgvPrimaryKPI(MyEmpID);
        fillgvRealTimeOptimization(MyEmpID);
        fillLtlEI(MyEmpID);
        fillltlAbsenteeism(MyEmpID);
        fillpnlBTP("511TOT1");
        getFinalRating(MyEmpID);

    }

    protected void btnYesDiscussed_Click(object sender, EventArgs e)
    {
        btnAgree.Enabled = true;
        btnYesDiscussed.Enabled = false;
        btnNotDiscussed.Enabled = false;

        SqlConnection con = new SqlConnection(my.getConnectionString());
        con.Open();

        String strSQL = "[WFMPMS].[InsertPacmanStage]";
        SqlCommand cmd = new SqlCommand(strSQL, con);
        cmd.CommandType = CommandType.StoredProcedure;

        MyEmpID = Convert.ToInt32(dtEmp.Rows[0]["Employee_Id"].ToString());
        int Stage = 4;
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
        //enableDisableButtons();
    }

    protected void btnAgree_Click(object sender, EventArgs e)
    {
        btnYesDiscussed.Enabled = false;
        btnNotDiscussed.Enabled = false;
        btnAgree.Enabled = false;

        SqlConnection con = new SqlConnection(my.getConnectionString());
        con.Open();

        String strSQL = "[WFMPMS].[InsertPacmanStage]";
        SqlCommand cmd = new SqlCommand(strSQL, con);
        cmd.CommandType = CommandType.StoredProcedure;

        MyEmpID = Convert.ToInt32(dtEmp.Rows[0]["Employee_Id"].ToString());
        int Stage = 5;
        int PreviousStage = 4;
        PacmanCycle = Convert.ToInt32(ddlReviewPeriod.SelectedItem.Value.ToString());
        cmd.Parameters.AddWithValue("@EmpCode", MyEmpID);
        cmd.Parameters.AddWithValue("@Stage", Stage);
        cmd.Parameters.AddWithValue("@PacmanCycle", PacmanCycle);
        cmd.Parameters.AddWithValue("@ActionBy", MyEmpID);
        cmd.Parameters.AddWithValue("@PreviousStage", PreviousStage);

        cmd.Connection = con;
        cmd.ExecuteNonQuery();
        con.Close();

        enableDisableButtons();
    }

    private void fillltlIEXMgmt(int ForEmpID)
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

    private void fillltlAnalyticProject(int ForEmpID)
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

    private void fillltlAnalyticCoaching(int ForEmpID)
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

    private void fillltlAnalyticTimeline(int ForEmpID)
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

    private void fillltlAccuracy(int ForEmpID)
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
}