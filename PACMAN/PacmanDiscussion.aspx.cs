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
using System.IO;
using CsvHelper;

public partial class PacmanDiscussion : System.Web.UI.Page
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
    public string lblPeriodID { get; set; }
    public DataTable DtOfAccountsIHandle { get; set; }
    private decimal FinalRating { get; set; }
   

    public DataTable DtProcName { get; set; }
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

        btnSubmitPacman.Enabled = true;
        btnYesDiscussed.Enabled = true;


        //btnSubmitPacman.Enabled = true;


        if (!IsPostBack)
        {
            fillddlReviewPeriod();
            fillddlStage();
        }
    }




    private void fillddlReviewPeriod()
    {
        string strSQL = "WFMPMS.GetPacmanCycleforPacmanDiscussion_g";
        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.CommandType = CommandType.StoredProcedure;

        DataTable dtReportee = my.GetData(ref cmd);
        ddlReviewPeriod.DataSource = dtReportee;
        ddlReviewPeriod.DataTextField = "Period";
        ddlReviewPeriod.DataValueField = "PeriodID";
        ddlReviewPeriod.DataBind();
        ddlReviewPeriod.SelectedIndex = 0;
    }
    private void fillddlStage()
    {
        int PeriodID = Convert.ToInt32(ddlReviewPeriod.SelectedValue);
        string strSQL = @"select * from [PMS].[Lock] where Active = 1";
        SqlCommand cmd = new SqlCommand(strSQL);

        DataTable dt1 = my.GetData(ref cmd);
        ddlStage.DataSource = dt1;
        ddlStage.DataTextField = "LockType";
        ddlStage.DataValueField = "LockID";
        ddlStage.DataBind();
        ListItem i = new ListItem("Pending", "0");
        ddlStage.Items.Insert(0, i);
        ddlStage.SelectedIndex = 0;
        fillddlReportee();
    }
    protected void ddlStage_SelectedIndexChanged(object sender, EventArgs e)
    {
        fillddlReportee();
    }
    protected void ddlReviewPeriod_SelectedIndexChanged(object sender, EventArgs e)
    {
        PeriodID = Convert.ToInt32(ddlReviewPeriod.SelectedValue);
        string strSQL = "SELECT [FromDate],[ToDate] FROM [PMS].[PeriodMst] where [PeriodID] =" + PeriodID;
        DataTable dt = my.GetData(strSQL);
        StartDate = Convert.ToDateTime(dt.Rows[0]["FromDate"].ToString());
        EndDate = Convert.ToDateTime(dt.Rows[0]["ToDate"].ToString());
        fillddlStage();

        populateHeaders();

    }

    private void populateHeaders()
    {
        PeriodID = Convert.ToInt32(ddlReviewPeriod.SelectedValue);
        string strSQL = "WFMPMS.getReporteeList";
        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@RepMgr", MyEmpID);
        cmd.Parameters.AddWithValue("@PeriodID", PeriodID);

        DataTable dtReportee = my.GetData(ref cmd);
        if (dtReportee!=null && ddlReportee.Items.Count > 0 && ddlReportee.SelectedIndex > 0)
        {
            
            DataRow[] drs = dtReportee.Select("EmpCode = " + ForEmpID.ToString());
            string Role = string.Empty;
            if (drs.Length == 1)
            {
                Role = drs[0]["Role"].ToString();
            }
            ltlEmployeeBanner.Text = ddlReportee.SelectedItem.Text.ToString() + "( " + ForEmpID + " ) | Role : " + Role;
        }
        else
        {
            ltlEmployeeBanner.Text = "Not found";
        }
    }

    private void fillStartAndEndDates()
    {
        PeriodID = Convert.ToInt32(ddlReviewPeriod.SelectedValue);
        string strSQL = "SELECT [FromDate],[ToDate] FROM [PMS].[PeriodMst] where [PeriodID] =" + PeriodID;
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
        int PeriodID = Convert.ToInt32(ddlReviewPeriod.SelectedValue);
        string strSQL = "WFMPMS.getReporteeList";
        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@RepMgr", MyEmpID);
        cmd.Parameters.AddWithValue("@PeriodID", PeriodID);

        DataTable dt2 = my.GetData(ref cmd);
        ddlReportee.DataSource = dt2;
        ddlReportee.DataTextField = "Name";
        ddlReportee.DataValueField = "EmpCode";
        ddlReportee.DataBind();
    }

    protected void btnYesDiscussed_Click(object sender, EventArgs e)
    {

    }
    protected void ddlStage_DataBound(object sender, EventArgs e)
    {

    }

    protected void ddlReportee_SelectedIndexChanged(object sender, EventArgs e)
    {
        ForEmpID = Convert.ToInt32(ddlReportee.SelectedItem.Value.ToString());
        populateHeaders();
        fillRP(ForEmpID);
    }

    private void fillRP(int ForEmpID)
    {
        //PMS.FillKPI 880343,5
        int PeriodID = Convert.ToInt32(ddlReviewPeriod.SelectedValue.ToString());
        fillStartAndEndDates();
        strSQL = "PMS.FillKPI";
        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@EmpCode", ForEmpID);
        cmd.Parameters.AddWithValue("@PeriodID", PeriodID);

        DtProcName = my.GetData(ref cmd);
        rp.DataSource = DtProcName;
        rp.DataBind();


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


    protected void rp_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        GridView gv = e.Item.FindControlRecursive("gvKPI") as GridView;

        if (gv != null)
        {
            //string strSQL = "SELECT Distinct B.id, B.Metrics FROM [CWFM_Umang].[WFMPMS].[tblEmp2Account] A  ";
            //strSQL += " inner join [WFMPMS].[tblDsgn2KPIWtg] B on B.SkillsetId = A.SkillsetId  ";
            //strSQL += " where EmpCode =  " + ForEmpID + " and [Active] = 1 and '" + StartDate + "' between A.FromDate and A.ToDate ";
            //strSQL += " order by B.id, B.Metrics ";


            fillStartAndEndDates();

            if (DtProcName != null && DtProcName.Rows.Count > 0)
            {
                bool isManual;
                string procName = string.Empty;
                string Metric = string.Empty;
                foreach (DataRow dr in DtProcName.Rows)
                {
                    isManual = Convert.ToBoolean(dr["isManual"].ToString());
                    procName = dr["ProcName"].ToString();
                    Literal ltlKPIName = e.Item.FindControlRecursive("ltlKPIName") as Literal;
                    Metric = dr["Metric"].ToString();
                    if (ltlKPIName.Text == Metric)
                    {
                        if (!isManual && procName.Length > 0)
                        {


                            SqlCommand cmd = new SqlCommand();
                            cmd.CommandText = procName;
                            cmd.CommandType = CommandType.StoredProcedure;
                            cmd.Parameters.AddWithValue("@EmpCode", ForEmpID);
                            //cmd.Parameters.AddWithValue("@StartDate", StartDate);
                            //cmd.Parameters.AddWithValue("@EndDate", EndDate);
                            cmd.Parameters.AddWithValue("@StartDate", "20180401");
                            cmd.Parameters.AddWithValue("@EndDate", "20180430");


                            DataTable dt = my.GetData(ref cmd);
                            gv.DataSource = dt;
                            gv.DataBind();
                            string Rating = string.Empty;
                            DataRow[] drs = dt.Select("Account = 'Grand Total'");
                            if (drs.Length == 1)
                            {
                                foreach(DataRow r in drs)
                                {
                                    Rating = r["Rating"].ToString();

                                }
                                
                                Literal ltlfinalScore = e.Item.FindControlRecursive("ltlKPIScore") as Literal;
                                ltlfinalScore.Text = Rating.ToString();
                                Decimal KPIRating = Convert.ToDecimal(Rating);
                                Decimal KPIWtg = Convert.ToDecimal(dr["KPIWtg"].ToString());
                                FinalRating += KPIRating * KPIWtg;
                                ltlFinalRating.Text = Math.Round(FinalRating,2).ToString();
                            }
                            
                        }

                        

                    }

                }

            }
            else
            {
                rp.Visible = false;
                ltlFinalRating.Text = "0";
            }
        }

    }


    public void fillpnlKPI(ref GridView gv)
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
            fillpnlKPIforManagers(ForEmpID);
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
    private void fillpnlKPIforManagers(int ForEmpID, string metric = "KPI")
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


            }
            else
            {

            }

        }
        else
        {


        }
    }

    private DataTable getDtOfAccountsIHandle(int ForEmpID)
    {
        string strSQL = "WFMPMS.GetAllAccountsIHandle";
        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.Parameters.AddWithValue("@Employee_ID", ForEmpID);
        StartDate = DateTime.Today.Date;
        DataTable dt = my.GetDataTableViaProcedure(ref cmd);
        return dt;
    }


    protected void rp_PreRender(object sender, EventArgs e)
    {

    }
}
