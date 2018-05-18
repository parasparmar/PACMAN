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
    private int AttritionRating { get; set; }
    private int AnalyticProject { get; set; }
    private int AnalyticCoaching { get; set; }
    private int AnalyticTimeline { get; set; }
    private int Accuracy { get; set; }
    private int CurrentStage { get; set; }
    private int EachKPI_Score { get; set; }
    private int IsManager { get; set; }
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
                if (dtEmp == null)
                {
                    Response.Redirect("index.aspx", false);
                }
                else
                {
                    // In Production Use the below
                    MyEmpID = Convert.ToInt32(dtEmp.Rows[0]["Employee_Id"].ToString());
                    MyName = dtEmp.Rows[0]["First_Name"].ToString() + " " + dtEmp.Rows[0]["Middle_Name"].ToString() + " " + dtEmp.Rows[0]["Last_Name"].ToString();
                    MyRepMgr = Convert.ToInt32(dtEmp.Rows[0]["RepMgrCode"].ToString());
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
            title.Text = "PACMAN";
            fillddlReviewPeriod();
            enableDisableButtons();
            //getNamePacmanCycle();
            //DtOfAccountsIHandle = getDtOfAccountsIHandle();
            showRelevantMetricPanels(MyEmpID);


        }
        else
        {
            try
            {
                dtEmp = (DataTable)Session["dtEmp"];
                if (dtEmp != null && dtEmp.Rows.Count <= 0)
                {
                    Response.Redirect("index.aspx", false);
                }
                else
                {
                    // In Production Use the below
                    MyEmpID = Convert.ToInt32(dtEmp.Rows[0]["Employee_Id"].ToString());
                    MyRepMgr = Convert.ToInt32(dtEmp.Rows[0]["RepMgrCode"].ToString());
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
        }

    }
    private DataTable getDtOfAccountsIHandle(int ForEmpID)
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
                        rating = r["Rating"],
                        primarykpitarget = r["PrimaryKPITarget"]
                    } into groupby
                    where groupby.Key.account.ToString().Contains("Total") != true
                    select new
                    {
                        accountid = groupby.Key.accountid,
                        account = groupby.Key.account,
                        rating = groupby.Key.rating,
                        primarykpitarget = groupby.Key.primarykpitarget,
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
                    Response.Write(Ex.Message.ToString() + "Something's wrong with " + myPanelName);
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
            StartDate = new DateTime(DateTime.Today.Year, DateTime.Today.Month, 1);
            EndDate = new DateTime(DateTime.Today.Year, DateTime.Today.Month, 31);
        }

    }
    private void getFinalRating(int ForEmpID)
    {


        string strSQL = @"SELECT Distinct B.id, B.Metrics, B.Weight FROM [CWFM_Umang].[WFMPMS].[tblEmp2Account] A  
        inner join [WFMPMS].[tblDsgn2KPIWtg] B on B.SkillsetId = A.SkillsetId
        where EmpCode =  @ForEmpID and [Active] = 1 and @StartDate between A.FromDate and A.ToDate 
        order by B.id, B.Metrics, B.Weight";
        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.Parameters.AddWithValue("@ForEmpID", ForEmpID);
        cmd.Parameters.AddWithValue("@StartDate", StartDate);

        FinalRating = 0;
        DataTable dtWeights = my.GetData(ref cmd);
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
        {
            ltlfinalScore.Text = Math.Round(FinalRating, 2).ToString();
        }

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
            gvAbsenteeism.RowStyle.CssClass = "text-muted well well-sm no-shadow";
            gvAbsenteeism.Rows[0].Font.Bold = true;
            gvAbsenteeism.PreRender += gv_PreRender;
            string absRating = dt.Rows[0]["Final_Score"].ToString();
            ltl_Absenteeism.Text = absRating;
            //Decimal dcAbsRting = 5;
            //Decimal.TryParse(absRating, out dcAbsRting);
            //AbsenteeismRating = dcAbsRting;
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

        string strSQL1 = "[WFMPMS].[getAttritionScore]";

        SqlCommand cmd1 = new SqlCommand(strSQL1);
        cmd1.CommandType = CommandType.StoredProcedure;
        cmd1.Parameters.AddWithValue("@EmpCode", MyEmpID);
        cmd1.Parameters.AddWithValue("@StartDate", StartDate);
        cmd1.Parameters.AddWithValue("@EndDate", EndDate);
        //cmd1.Parameters.AddWithValue("@Metric", metric);

        DataTable dt1 = my.GetDataTableViaProcedure(ref cmd1);
        if (dt1 != null)
        {
            GridView gvAttrition = new GridView();
            gvAttrition.ID = "gvAttrition";
            gvAttrition.AutoGenerateColumns = true;
            //gvPrimaryKPI.EmptyDataTemplate =  "No data found matching this set of parameters " + MyEmpID + StartDate.Month.ToString("M");

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
            //gvPrimaryKPI.EmptyDataTemplate =  "No data found matching this set of parameters " + MyEmpID + StartDate.Month.ToString("M");

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
            //gvSelfAbsenteeism.Rows[gvSelfAbsenteeism.Rows.Count - 1].CssClass = "text-muted well well-sm no-shadow";
            //gvSelfAbsenteeism.Rows[gvSelfAbsenteeism.Rows.Count - 1].Font.Bold = true;
            //gvSelfAbsenteeism.PreRender += gv_PreRender;
            //string absRating = dt.Rows[dt.Rows.Count - 1]["Rating"].ToString();
            //Decimal dcAbsRting = 5;
            //Decimal.TryParse(absRating, out dcAbsRting);
            //SelfAbsenteeismRating = dcAbsRting;
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
                cmd.Parameters.AddWithValue("@PacmanCycle", PacmanCycle);
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
            PacmanCycle = Convert.ToInt32(ddlReviewPeriod.SelectedValue);
            string strSQL = "SELECT [FromDate],[ToDate] FROM [CWFM_Umang].[WFMPMS].[tblPacmanCycle] where [ID] =" + PacmanCycle;
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
        //string metric = "Escalations";
        //if (IsManager == 1)
        //{
        //    string strSQL1 = "[WFMPMS].[GetManagerKPI]";

        //    SqlCommand cmd1 = new SqlCommand(strSQL1);
        //    cmd1.CommandType = CommandType.StoredProcedure;
        //    cmd1.Parameters.AddWithValue("@EmpCode", ForEmpID);
        //    cmd1.Parameters.AddWithValue("@StartDate", StartDate);
        //    cmd1.Parameters.AddWithValue("@EndDate", EndDate);
        //    cmd1.Parameters.AddWithValue("@Metric", metric);

        //    DataTable dt1 = my.GetDataTableViaProcedure(ref cmd1);
        //    if (dt1 != null)
        //    {
        //        GridView gvEscalations = new GridView();
        //        gvEscalations.ID = "gvEscalations";
        //        gvEscalations.AutoGenerateColumns = true;
        //        //gvPrimaryKPI.EmptyDataTemplate =  "No data found matching this set of parameters " + MyEmpID + StartDate.Month.ToString("M");

        //        DataRow dr1 = dt1.NewRow();

        //        gvEscalations.DataSource = dt1;
        //        gvEscalations.CssClass = "table DataTable table-condensed table-bordered table-responsive";
        //        gvEscalations.DataBind();
        //        if (dt1.Rows.Count > 0)
        //        {
        //            gvEscalations.Rows[gvEscalations.Rows.Count - 1].CssClass = "text-muted well well-sm no-shadow";
        //            gvEscalations.Rows[gvEscalations.Rows.Count - 1].Font.Bold = true;
        //            gvEscalations.PreRender += gv_PreRender;
        //            //SLRating = Convert.ToDecimal(dt1.Rows[dt1.Rows.Count - 1]["Metric_Score"].ToString());
        //            EIRating = Convert.ToInt32(dt1.Rows[dt1.Rows.Count - 1]["Metric_Score"].ToString());
        //            ltlEI.Text = "Escalations & Initiatives &nbsp= &nbsp";
        //            pnlBTP.Controls.Add(gvEscalations);
        //            ltl_Escalations.Text = EIRating.ToString();
        //        }


        //        pnlEscalations.Controls.Add(gvEscalations);
        //    }
        //}
        //else
        //{
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
        //}
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
                //gvPrimaryKPI.EmptyDataTemplate =  "No data found matching this set of parameters " + MyEmpID + StartDate.Month.ToString("M");

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
                //gvPrimaryKPI.EmptyDataTemplate =  "No data found matching this set of parameters " + MyEmpID + StartDate.Month.ToString("M");

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
                    //HeadcountAccuracy = Convert.ToDecimal(dt.Rows[dt.Rows.Count - 1]["Rating"].ToString());
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
        string metric2Download;

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
                if (IsManager == 1)
                {
                    strSQL = "wfmpms.getAttritionDetail";
                    cmd.CommandType = CommandType.StoredProcedure;
                }
                break;
            case "BTP":
                metric2Download = "BTP";
                if (IsManager == 1)
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
                if (IsManager == 1)
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
                if (IsManager == 1)
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
                strSQL = "SELECT EmpCode, Comments, ActionedBy, ActionedOn, Score as Rating, B.FromDate as StartDate, B.ToDate as EndDate ";
                strSQL += " FROM[CWFM_Umang].[WFMPMS].[tblIEXManagementScore] A inner join WFMPMs.tblPacmanCycle B on A.PacmanCycle = B.ID ";
                strSQL += " where[EmpCode] = @EmpCode and B.FromDate between @StartDate and @EndDate ";
                break;
            case "KPI":
                metric2Download = "KPI";
                if (IsManager == 1)
                {
                    strSQL = "wfmpms.getmanagerdownload";
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@metric", metric2Download);
                }
                else
                {
                    strSQL = "SELECT * FROM [WFMPMS].[tblKPIResults] where [Employee_ID] = @EmpCode and [Date] between @StartDate and @EndDate";
                }

                break;
            case "On_Time_Delivery":
                strSQL = "WFMPMS.GetAnalyticTimelineScore";
                cmd.CommandType = CommandType.StoredProcedure;
                break;

            case "Optimization"://Real_Time_Optimization


                break;
            case "Projects":
                strSQL = "WFMPMS.getAnalyticProjectScore";
                cmd.CommandType = CommandType.StoredProcedure;
                break;

            case "Revenue__Cost_optimization":
                // Manager KPIs
                break;
            case "Scheduling_Accuracy":
                metric2Download = "Scheduling_Accuracy";
                if (IsManager == 1)
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
                if (IsManager == 1)
                {
                    strSQL = "wfmpms.getmanagerdownload";
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@metric", metric2Download);
                }
                break;


            case "Download":

                break;
            default:

                break;
        }

        cmd.CommandText = strSQL;
        cmd.Connection = new SqlConnection(my.getConnectionString());
        cmd.Connection.Open();

        string MyName = my.getFirstResult("select dbo.getFullName(" + MyEmpID + ") as FullName");
        string FileName = MyName + "'s " + Metric + " for " + StartDate.ToString("MMM yyyy") + " downloaded " + DateTime.Now.ToString("dd-MMM-yyyy HH-mm-ss") + ".csv";
        DataTable d = my.GetData(ref cmd);
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
}

