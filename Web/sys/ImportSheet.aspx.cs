using OfficeOpenXml;
using System;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;

public partial class sys_ImportSheet : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack && Upload.HasFile)
        {
            UploadSheet();
        }
    }

    void UploadSheet()
    {
        if (Path.GetExtension(Upload.FileName).Equals(".xlsx"))
        {
            var excel = new ExcelPackage(Upload.FileContent);
            var dt = excel.ToDataTable();
            string table = "Contacts";

            using (var conn = new SqlConnection(Config.connString))
            {
                // fire triggers that help merge contacts.
                var bulkCopy = new SqlBulkCopy(conn.ConnectionString, SqlBulkCopyOptions.FireTriggers);
                bulkCopy.DestinationTableName = table;
                conn.Open();
                var schema = conn.GetSchema("Columns", new[] { null, null, table, null });

                try
                {
                    foreach (DataColumn sourceColumn in dt.Columns)
                    {
                        foreach (DataRow row in schema.Rows)
                        {
                            if (string.Equals(sourceColumn.ColumnName, (string)row["COLUMN_NAME"], StringComparison.OrdinalIgnoreCase))
                            {
                                bulkCopy.ColumnMappings.Add(sourceColumn.ColumnName, (string)row["COLUMN_NAME"]);
                                break;
                            }
                        }
                    }
                    
                    bulkCopy.WriteToServerAsync(dt);
                    doneMessage.Text = "<div class='alert alert-block alert-success'>Data has been imported to clients list, start <a href='sendsms.aspx' class='bolder'>sending SMS</a> now.</div>";
                }
                catch (Exception ex)
                {
                    doneMessage.Text = "<div class='alert alert-block alert-warning'>Error uploading file: " + ex.Message + ", Please contact system administrator.</div>";
                }
                finally
                {
                    conn.Close();
                }

            }
        }
    }
}

public static class ExcelPackageExtensions
{
    public static DataTable ToDataTable(this ExcelPackage package)
    {
        ExcelWorksheet workSheet = package.Workbook.Worksheets.First();
        var table = new DataTable();
        foreach (var firstRowCell in workSheet.Cells[1, 1, 1, workSheet.Dimension.End.Column])
        {
            table.Columns.Add(firstRowCell.Text);
        }
        for (var rowNumber = 2; rowNumber <= workSheet.Dimension.End.Row; rowNumber++)
        {
            var row = workSheet.Cells[rowNumber, 1, rowNumber, workSheet.Dimension.End.Column];
            var newRow = table.NewRow();
            foreach (var cell in row)
            {
                newRow[cell.Start.Column - 1] = cell.Text;
            }
            table.Rows.Add(newRow);
        }
        return table;
    }
}