using namespace System.Data.SqlClient
using namespace System.Data

$Global:conf = Import-PowerShellDataFile .\conf.psd1


try {
    $SqlDataAdapter = [SqlDataAdapter]::new($Global:conf.Commands.SelectCommand, $Global:conf.ConnectionString)
    $SqlDataAdapter.UpdateCommand = [SqlCommand]::new("UPDATE [u1559145_alhaos_ru].[u1559145_user].[person] set [firstname] = @firstname, [lastname] = @lastname, [dob] = @dob WHERE [id] = @id", $Global:conf.ConnectionString)
    $SqlParameter = $SqlDataAdapter.UpdateCommand.Parameters.Add(
        '@id', [SqlDbType]::Int
    )
    $SqlParameter.SourceColumn = 'id'
    $SqlParameter.SourceVersion = [DataRowVersion]::Original

    $null = $SqlDataAdapter.UpdateCommand.Parameters.Add(
        '@firstname', [SqlDbType]::NVarChar, 15, 'firstname'
    )
    
    $null = $SqlDataAdapter.UpdateCommand.Parameters.Add(
        '@lastname', [SqlDbType]::NVarChar, 15, 'lastname'
    )
    
    $null = $SqlDataAdapter.UpdateCommand.Parameters.Add(
        '@dob', [SqlDbType]::DateTime, $null, 'dob'
    )
        
    $DataTable = [DataTable]::new('person')
    $null = $SqlDataAdapter.Fill($DataTable)
}
catch {
    throw $_
}
finally {

}

foreach ($Row in $DataTable.Rows) {
    $Row.firstname = $Row.firstname.TrimEnd('--')
} 

$SqlDataAdapter.Update($DataTable)