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

public partial class changerole : System.Web.UI.Page
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
        title.Text = "Change Role";

        if (!IsPostBack)
        {
            fillddlReviewPeriod();
            fillddlRole();

        }
    }
    private DataTable getDtOfAccountsIHandle(int ForEmpID)
    {
        string strSQL = "WFMPMS.GetAllAccountsIHandle";
        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.Parameters.AddWithValue("@Employee_ID", ForEmpID);
        DataTable dt = my.GetDataTableViaProcedure(ref cmd);
        return dt;
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
        fillddlRole();
        ddlReviewPeriod_SelectedIndexChanged(ddlReviewPeriod, new EventArgs());
    }
    private void fillddlRole()
    {
        string strSQL = "[PMS].[fillRole]";
        SqlCommand cmd = new SqlCommand(strSQL);
        DataTable dt1 = my.GetDataTableViaProcedure(ref cmd);
        ddlRole.DataSource = dt1;
        ddlRole.DataTextField = "Role";
        ddlRole.DataValueField = "RoleId";
        ddlRole.Items.Add(new ListItem("-- Please Select --", "0"));
        ddlRole.DataBind();
    }
    protected void ddlRole_SelectedIndexChanged(object sender, EventArgs e)
    {

    }
    protected void ddlReviewPeriod_SelectedIndexChanged(object sender, EventArgs e)
    {
        ltlRoleTitle.Text = "Role Change for Period : " + ddlReviewPeriod.SelectedItem.Text.ToString();
        fillddlRole();
        fillgvTeam(MyEmpID);
    }
    private void fillgvTeam(int ForEmpID)
    {
        PeriodID = Convert.ToInt32(ddlReviewPeriod.SelectedValue);
        string strSQL = "WFMPMS.fillEmployeePacmanDiscussion_g";
        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.Parameters.AddWithValue("@RepMgr", ForEmpID);
        cmd.Parameters.AddWithValue("@PeriodID", PeriodID);
        DataTable dt = my.GetDataTableViaProcedure(ref cmd);
        gvTeam.DataSource = dt;
        gvTeam.DataBind();

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



    protected void btnRolechangeSubmit_Click(object sender, EventArgs e)
    {

        List<SelectedEID> sEID = new List<SelectedEID>();
        int lastColumn = gvTeam.Columns.Count;
        int EIDIndex = gvTeam.GetGVCellUsingFieldName("Eligibility ID");
        int PeriodID = Convert.ToInt32(ddlReviewPeriod.SelectedValue.ToString());
        int RoleID = Convert.ToInt32(ddlRole.SelectedValue.ToString());
        foreach (GridViewRow g in gvTeam.Rows)
        {
            CheckBox cb = g.Cells[0].FindControlRecursive("cbEmpID") as CheckBox;
            if (cb != null && cb.Checked)
            {
                SelectedEID f = new SelectedEID();
                f.EID = Convert.ToInt32(g.Cells[EIDIndex].Text);
                f.PeriodID = PeriodID;
                f.RoleID = RoleID;
                sEID.Add(f);
            }
        }
        try
        {
           
            int rowsAffected = 0;
            foreach (var s in sEID)
            {                
                
                using (SqlCommand cmd = new SqlCommand("PMS.ChangeRole", my.open_db()))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@EID", s.EID);
                    cmd.Parameters.AddWithValue("@PeriodID", s.PeriodID);
                    cmd.Parameters.AddWithValue("@RoleID", s.RoleID);
                    cmd.Parameters.AddWithValue("@Msg",string.Empty);
                    cmd.Parameters["@Msg"].Direction = ParameterDirection.Output;

                    rowsAffected = cmd.ExecuteNonQuery();
                    s.Msg = cmd.Parameters["@Msg"].ToString();
                }


            }
        }
        catch (Exception E)
        {
            Response.Write("Failure Writing Role Change to the system. " + E.Message);
        }
        fillgvTeam(MyEmpID);
        //if(sEID!=null && sEID.Count > 0)
        //{
        //    foreach (GridViewRow r in gvTeam.Rows)
        //    {
        //        TextBox tb = r.Cells[4].FindControlRecursive("tbMsg") as TextBox;

        //        if (tb != null)
        //        {
        //            int EID = Convert.ToInt32(r.Cells[5].Text);
        //            tb.Text = sEID.Find(s => s.EID == EID).Msg.ToString();
        //        }
        //    }
        //}
       
    }
    public class SelectedEID
    {
        public int EID { get; set; }
        public int PeriodID { get; set; }
        public int RoleID { get; set; }
        public string Msg { get; set; }
    }
}

