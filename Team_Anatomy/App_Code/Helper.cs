﻿using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using context = System.Web.HttpContext;
using System.Web;
using CD;

public class Helper
{
    SqlConnection mcon;

    public Helper()
    {
        SqlConnection mcon = new SqlConnection(getConnectionString());
        if (mcon.State == ConnectionState.Closed || mcon.State == ConnectionState.Broken)
        {
            open_db();
        }
    }

    public string getConnectionString()
    {
        EDCryptor xEDCryptor = new EDCryptor();
        string xString = ConfigurationManager.ConnectionStrings["constr"].ToString();
        xString = xEDCryptor.DeCrypt(xString);
        return xString;
    }

    // ------------------------- Open Database Connection -------------------------
    public void open_db()
    {

        mcon = new SqlConnection(getConnectionString());
        try
        {
            if (mcon.State == ConnectionState.Closed || mcon.State == ConnectionState.Broken)
            {
                mcon.Open();
            }
        }
        catch (Exception e)
        {
            Console.WriteLine("{0} Exception Caught", e);
            Log.thisException(e);
        }
    }

    // ------------------------- Close  Database Connection -------------------------
    public void close_conn()
    {
        if (mcon.State == ConnectionState.Open)
        {
            mcon.Close();
            mcon.Dispose();
        }
    }


    // ------------------------- Procedure for Execute Sql Query/Stored Procedure -------------------------
    public int ExecuteDMLCommand(ref SqlCommand cmd, string sql_string, string operation)
    {
        if (mcon.State == ConnectionState.Closed || mcon.State == ConnectionState.Broken) { open_db(); }
        int returnValue = 0;
        try
        {
            //cmd = new SqlCommand(sql_string, mcon);
            cmd.Connection = mcon;
            if (operation == "E")
            {
                returnValue = cmd.ExecuteNonQuery();
            }
            else if (operation == "S")
            {

                cmd.CommandType = CommandType.StoredProcedure;
                returnValue = cmd.ExecuteNonQuery();
            }
        }
        catch (Exception e)
        {
            Log.thisException(e);

        }
        finally
        {

            // Paras 29-03-2017 : Don't close the connection here.
            //close_conn();

        }
        return returnValue;
    }

    public DataTable GetDataTableViaProcedure(ref SqlCommand cmd)
    {
        if (mcon.State == ConnectionState.Closed || mcon.State == ConnectionState.Broken) { open_db(); }
        DataTable dt = new DataTable();
        using (cmd)
        {
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Connection = mcon;

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
        }

        return dt;
    }

    // ------------------------- Function for return datatable -------------------------
    public DataTable GetData(string sql)
    {
        using (SqlConnection mcon = new SqlConnection(getConnectionString()))
        {

            DataTable dt = new DataTable();
            using (SqlDataAdapter da = new SqlDataAdapter(new SqlCommand(sql, mcon)))
            {
                DataSet ds = new DataSet();
                da.Fill(ds);
                dt = ds.Tables[0];
            }
            
            //close_conn();
            return dt;
        }

    }

    // ------------------------- Function for return datatable -------------------------
    public DataSet return_dataset(string sql)
    {
        open_db();
        DataTable worktable = new DataTable();
        SqlDataAdapter dap = new System.Data.SqlClient.SqlDataAdapter(new System.Data.SqlClient.SqlCommand(sql, mcon));
        DataSet ds = new DataSet();
        dap.Fill(ds);
        //close_conn();
        return ds;
    }

    // ------------------------- Procedure For fill ListBox with default item -------------------------
    public void fill_listbox(ref ListBox list_name, string sp_name, string datatextfeild, string datavaluefeild, string defaultitem, string parameters)
    {
        SqlCommand cmd = new SqlCommand();
        SqlDataAdapter dap = new SqlDataAdapter();
        DataSet ds = new DataSet();

        try
        {
            ExecuteDMLCommand(ref cmd, sp_name, "S");
            //----------------------- Addning Muiltipal Parameters with there values by split using '#'.
            if (parameters.Trim() != "")
            {
                string[] multiple_parameter = parameters.Split(',');
                foreach (string p_value in multiple_parameter)
                {
                    string para_name = p_value.Split('#')[0];
                    string para_value = p_value.Split('#')[1];
                    cmd.Parameters.AddWithValue("@" + para_name, para_value);
                }
            }

            dap.SelectCommand = cmd;
            dap.Fill(ds);

            if (defaultitem != "")
            {
                DataRow dr = ds.Tables[0].NewRow();
                dr[0] = 0;
                dr[1] = defaultitem;
                ds.Tables[0].Rows.Add(dr);
            }
            list_name.DataSource = ds.Tables[0];
            list_name.DataTextField = datatextfeild;
            list_name.DataValueField = datavaluefeild;
            list_name.DataBind();


            //--------------------------------------------
            if (defaultitem != "")
            {
                list_name.SelectedValue = "0";
            }
        }
        catch (Exception e)
        {
            Log.thisException(e);
        }
        finally
        {
            dap.Dispose();
            ds.Dispose();
            close_conn();
        }

    }


    // ------------------------- Procedure For fill dropdownlist with default item -------------------------
    public void fill_dropdown(ref DropDownList drp_name, string sp_name, string datatextfeild, string datavaluefeild, string defaultitem, string parameters, string tran_type)
    {
        SqlCommand cmd = new SqlCommand();
        SqlDataAdapter dap = new SqlDataAdapter();
        DataSet ds = new DataSet();
        try
        {
            ExecuteDMLCommand(ref cmd, sp_name, tran_type);
            //----------------------- Addning Muiltipal Parameters with there values by split using '#' only if it is stored procedure.
            if (tran_type == "S")
            {
                if (parameters.Trim() != "")
                {
                    string[] multiple_parameter = parameters.Split(',');
                    foreach (string p_value in multiple_parameter)
                    {
                        string para_name = p_value.Split('#')[0];
                        string para_value = p_value.Split('#')[1];
                        cmd.Parameters.AddWithValue("@" + para_name, para_value);
                    }
                }
            }

            dap.SelectCommand = cmd;
            dap.Fill(ds);

            if (defaultitem != "")
            {
                DataRow dr = ds.Tables[0].NewRow();
                dr[0] = 0;
                dr[1] = defaultitem;
                ds.Tables[0].Rows.Add(dr);
            }
            drp_name.DataSource = ds.Tables[0];
            drp_name.DataTextField = datatextfeild;
            drp_name.DataValueField = datavaluefeild;
            drp_name.DataBind();


            //--------------------------------------------
            if (defaultitem != "")
            {
                drp_name.SelectedValue = "0";
            }
        }
        catch (Exception e)
        {
            Log.thisException(e);
        }
        finally
        {
            dap.Dispose();
            ds.Dispose();
            close_conn();
        }

    }


    // ------------------------- Procedure For fill Gridview with Blank row -------------------------
    public void fill_gridview(ref GridView gridname, string sql_string)
    {
        SqlCommand cmd = new SqlCommand();
        SqlDataAdapter dap = new SqlDataAdapter();
        DataSet ds = new DataSet();
        try
        {
            ExecuteDMLCommand(ref cmd, sql_string, "E");
            dap.SelectCommand = cmd;
            dap.Fill(ds);
            //------------------------  Add blank row in gridview if no record found ---- else bind gridview
            if (ds.Tables[0].Rows.Count == 0)
            {
                ds.Tables[0].Rows.Add(ds.Tables[0].NewRow());
                gridname.DataSource = ds.Tables[0];
                gridname.DataBind();

                int columncount = gridname.Rows[0].Cells.Count;
                gridname.Rows[0].Cells.Clear();
                gridname.Rows[0].Cells.Add(new TableCell());
                gridname.Rows[0].Cells[0].ColumnSpan = columncount;
                gridname.Rows[0].Cells[0].Text = "No Items in List";
                gridname.Rows[0].Cells[0].HorizontalAlign = HorizontalAlign.Center;
                gridname.Rows[0].Cells[0].Font.Bold = true;
                gridname.Rows[0].Cells[0].Font.Size = 8;
            }
            else
            {
                gridname.DataSource = ds.Tables[0];
                gridname.DataBind();
            }

        }
        catch (Exception e)
        {
            Log.thisException(e);
        }
        finally
        {
            cmd.Dispose();
            dap.Dispose();
            close_conn();
        }
    }


    // ------------------------- Display Page heading Name -------------------------
    public void set_pageheading(string heading, Page pagename)
    {
        Label lblheading = (Label)pagename.Master.FindControl("lblheading");
        if (lblheading != null)
        {
            lblheading.Visible = true;
            lblheading.Text = heading;
        }
    }

    public int getSingleton(string strSQL)
    {
        open_db();
        SqlCommand cmd = new SqlCommand(strSQL, mcon);
        var the_result = cmd.ExecuteScalar();
        int result = 0;
        if (Int32.TryParse(the_result.ToString(), out result))
        {
            return result;
        }
        else
        {
            return 0;
        };
    }

    public void fill_dropdown(Control drp_name, string sp_name, string datatextfield, string datavaluefield, string defaultitem, string parameters, string tran_type)
    {
        SqlCommand cmd = new SqlCommand(sp_name, mcon);
        cmd.CommandType = CommandType.StoredProcedure;
        SqlDataAdapter dap = new SqlDataAdapter();
        DataSet ds = new DataSet();

        try
        {
            DropDownList v = (DropDownList)drp_name;

            ExecuteDMLCommand(ref cmd, sp_name, tran_type);
            //----------------------- Addning Muiltipal Parameters with there values by split using '#' only if it is stored procedure.
            if (tran_type == "S")
            {
                if (parameters.Trim() != "")
                {
                    string[] multiple_parameter = parameters.Split(',');
                    foreach (string p_value in multiple_parameter)
                    {
                        string para_name = p_value.Split('#')[0];
                        string para_value = p_value.Split('#')[1];
                        cmd.Parameters.AddWithValue("@" + para_name, para_value);
                    }
                }
            }

            dap.SelectCommand = cmd;
            dap.Fill(ds);




            if (defaultitem != "")
            {
                DataRow dr = ds.Tables[0].NewRow();
                dr[0] = 0;
                dr[1] = defaultitem;
                ds.Tables[0].Rows.Add(dr);
            }
            v.DataSource = ds.Tables[0];
            v.DataTextField = datatextfield;
            v.DataValueField = datavaluefield;
            v.DataBind();


            //--------------------------------------------
            if (defaultitem != "")
            {
                v.SelectedValue = "0";
            }
        }
        catch (Exception e)
        {
            Log.thisException(e);
        }
        finally
        {
            dap.Dispose();
            ds.Dispose();
            close_conn();
        }
    }

    public void append_dropdown(ref DropDownList drp_name, string sp_name, int TextPosition, int ValuePosition)
    {


        using (SqlCommand cmd = new SqlCommand(sp_name, mcon))
        {
            using (SqlDataReader dr = cmd.ExecuteReader())
            {
                try
                {
                    DropDownList dp = (DropDownList)drp_name;

                    while (dr.Read())
                    {
                        dp.Items.Add(new ListItem(dr.GetValue(TextPosition).ToString(), dr.GetValue(ValuePosition).ToString()));
                    }

                }
                catch (Exception Ex)
                {
                    Console.Write(Ex.Message.ToString());
                }
            }
        }


    }

}
