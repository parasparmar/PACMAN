using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;


public partial class chart : System.Web.UI.Page
{
    DataTable dtEmp;
    Helper my;
    private string strSQL { get; set; }
    private int MyEmpID { get; set; }
    string myID;
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
                MyEmpID = dtEmp.Rows[0]["Employee_Id"].ToString().ToInt32();
            }
        }
        catch (Exception Ex)
        {
            Console.WriteLine(Ex.Message.ToString());
            Response.Redirect(ViewState["PreviousPageUrl"] != null ? ViewState["PreviousPageUrl"].ToString() : "index.aspx", false);
        }
        Literal title = (Literal)PageExtensionMethods.FindControlRecursive(Master, "ltlPageTitle");
        title.Text = "Charts";

        if (!IsPostBack)
        {
            FillTeamList9box();
        }
    }

    private void FillTeamList9box()
    {
        int RepMgrCode = MyEmpID;
        SqlCommand cmd = new SqlCommand("FillTeamList9box");
        cmd.Parameters.AddWithValue("@RepMgrCode", RepMgrCode);
        DataTable dt = my.GetDataTableViaProcedure(ref cmd);
        lvMGR.DataSource = dt;
        lvMGR.DataBind();
    }

    private void fillLvSkill()
    {

    }
    
    [WebMethod]
    public static List<NineBubbleChart> GetBubbleChart(string EMPCODE)
    {
        Helper my = new Helper();
        string query = "FillChart9box";
        SqlCommand cmd = new SqlCommand(query);
        cmd.Parameters.AddWithValue("@EMPCODE", EMPCODE);
        DataTable dt = my.GetDataTableViaProcedure(ref cmd);
        DataView dv = new DataView(dt, "repmgrcode", "ASC", DataViewRowState.CurrentRows);

        List<NineBubbleChart> objList = new List<NineBubbleChart>();
        objList = (from DataRow dr in dv
                   select new NineBubbleChart()
                   {
                       EmpCode = dr["EMPCODE"].ToString(),
                       Name = dr["NAME"].ToString(),
                       Performance = dr["PERFORMANCE"].ToString(),
                       Competency = dr["COMPETENCY"].ToString(),
                       Radius = dr["RADIUS"].ToString()

                   }).ToList();
        return objList;
    }
    public class NineBubbleChart
    {
        public string EmpCode { get; set; }
        public string Name { get; set; }
        public string Performance { get; set; }
        public string Competency { get; set; }
        public string Radius { get; set; }
    }
    public class TypeList
    {
        public string Value { get; set; }
        public string Text { get; set; }
    }
    public class DesignationList
    {
        public string Value { get; set; }
        public string Text { get; set; }
    }
    public class LoginList
    {
        public string Value { get; set; }
        public string Text { get; set; }
    }
}