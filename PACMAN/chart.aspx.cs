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
using CD;

public partial class chart : System.Web.UI.Page
{
    Helper my = new Helper();
    private int MyEmpID { get; set; }
    DataTable dtEmp { get; set; }
    string myID;
    protected void Page_Load(object sender, EventArgs e)
    {
        myID = PageExtensionMethods.getMyWindowsID().ToString();
        myID = "ctirt002";
        RedirectBasedOnNTNameLookup(myID);
        dtEmp =(DataTable) Session["dtEmp"];
        hfMgrId.Value = Convert.ToString(dtEmp.Rows[0]["Employee_ID"]);
    }

    private void RedirectBasedOnNTNameLookup(string myID)
    {

        DataTable dt = new DataTable();
        if (myID != "IDNotFound")
        {
            //myID = "mchau006"; // atike001 Pdsou014 vchoh001 mchau006 ykand001// RTA Vinod Chauhan sbodh001 vfern016  fjaya001 smerc021  vpere018 Pdsou014  nrodr058  mshai066

            SqlCommand cmd = new SqlCommand("WFMP.getEmployeeData");
            //myID = "pgora001";//to login as other userk slall002  rshar030 nchan016 utiwa002  aansa012 paloz001 pjite001 g.001 adube010 utiwa002 avish001 vshir001
            cmd.Parameters.AddWithValue("@NT_ID", myID);

            try
            {
                dt = my.GetDataTableViaProcedure(ref cmd);
                if (dt != null && dt.Rows.Count > 0)
                {
                    Session["dtEmp"] = dt;

                    //Response.Redirect("chart.aspx", false);
                }
                else
                {
                    // Every page in the application will use the session 'myID' as the NTName of the unauthorized user.
                    Session["myID"] = myID;
                    Response.Redirect("lockscreen.aspx", false);
                }
            }
            catch (Exception Ex)
            {
                Response.Write(Ex.Message);
            }
        }
        else
        {
            Response.Redirect("lockscreen.aspx", false);
        }


    }

    [WebMethod]
    public static List<TypeList> GetDropDownDataTypeList(string RepMgrCode)
    {
        Helper my = new Helper();
        string query = "FillTeamList9box";
        string constr = ConfigurationManager.ConnectionStrings["constr"].ConnectionString;
        EDCryptor xEDCryptor = new EDCryptor();
        string con = xEDCryptor.DeCrypt(constr);
        //xtype = "798904";
        SqlCommand cmd = new SqlCommand(query);
        cmd.Parameters.AddWithValue("@RepMgrCode", RepMgrCode);
        DataTable dt = my.GetDataTableViaProcedure(ref cmd);
        List<TypeList> objList = new List<TypeList>();
        objList = (from DataRow dr in dt.Rows
                   select new TypeList()
                   {
                       Value = dr["EmpCode"].ToString(),
                       Text = dr["Name"].ToString()

                   }).ToList();
        return objList;
    }


    [WebMethod]
    public static List<TypeList> GetFillDesignationList(string EmpCode)
    {
        Helper my = new Helper();
        string query = "FillDesignation9Box";
        string constr = ConfigurationManager.ConnectionStrings["constr"].ConnectionString;
        EDCryptor xEDCryptor = new EDCryptor();
        string con = xEDCryptor.DeCrypt(constr);
        //xtype = "798904";
        SqlCommand cmd = new SqlCommand(query);
        cmd.Parameters.AddWithValue("@RepMgrCode", EmpCode);
        DataTable dt = my.GetDataTableViaProcedure(ref cmd);
        List<TypeList> objList = new List<TypeList>();
        objList = (from DataRow dr in dt.Rows
                   select new TypeList()
                   {
                       Value = dr["DESIGNATION"].ToString(),
                       Text = dr["DESIGNATION"].ToString()

                   }).ToList();
        return objList;
    }


    [WebMethod]
    public static List<NineBubbleChart> GetBubbleChart(string stageID)
    {
        Helper my = new Helper();
        string query = "FillChart9box";
        string constr = ConfigurationManager.ConnectionStrings["constr"].ConnectionString;
        EDCryptor xEDCryptor = new EDCryptor();
        string con = xEDCryptor.DeCrypt(constr);

        SqlCommand cmd = new SqlCommand(query);
        cmd.Parameters.AddWithValue("@StageID", stageID);
        DataTable dt = my.GetDataTableViaProcedure(ref cmd);
        List<NineBubbleChart> objList = new List<NineBubbleChart>();
        objList = (from DataRow dr in dt.Rows
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