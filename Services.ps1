# Description of what this script does along with the scripts author and date of creation
Write-Host("-----------------------------------------------------------------------------------------------")
Write-Host("Lists services on the computer - Author: NTeakle - Date: 26/07/2022")
Write-Host("")
Write-Host("This script will prompt the user with a GUI where they can input the target computr, the script will then list all the services on the desired computer")
Write-Host("")


# Asks the User whether or not they wish to proceed, can proceed by inputting either 'Yes' or 'No'
$title = 'something'
$question = "Are you sure you want to proceed?"


# Users choices on their inputs
$choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))


# Prompts the User with a UI, then takes the User's input and writes an output, confirming their input value
$decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
    if ($decision -eq 0) {
        Write-Host 'confirmed'
    } else {
        Write-Host 'cancelled'
    }


# This code (below block is not mine) searches a computer by name and shows all services currently running, the code also utilises a templated GUI.
Add-Type -AssemblyName PresentationFramework
[xml]$XAMLWindow = '
<Window
xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
Height="Auto"
SizeToContent="WidthAndHeight"
Title="Get-Service">
<ScrollViewer Padding="10,10,10,0" ScrollViewer.VerticalScrollBarVisibility="Disabled">
<StackPanel>
<StackPanel Orientation="Horizontal">
<Label Margin="10,10,0,10">ComputerName:</Label>
<TextBox Name="Input" Margin="10" Width="250px"></TextBox>
</StackPanel>
<DockPanel>
<Button Name="ButtonGetService" Content="Get-Service" Margin="10"
Width="150px" IsEnabled="false"/>
<Button Name="ButtonClose" Content="Close" HorizontalAlignment="Right"
Margin="10" Width="50px"/>
</DockPanel>
</StackPanel>
</ScrollViewer >
</Window>
'


# Create the Window Object
$Reader=(New-Object System.Xml.XmlNodeReader $XAMLWindow)
$Window=[Windows.Markup.XamlReader]::Load( $Reader )


# TextChanged Event Handler for Input
$TextboxInput = $Window.FindName("Input")
$TextboxInput.add_TextChanged.Invoke({
$ComputerName = $TextboxInput.Text
$ButtonGetService.IsEnabled = $ComputerName -ne ''
})


# Click Event Handler for ButtonClose
$ButtonClose = $Window.FindName("ButtonClose")
$ButtonClose.add_Click.Invoke({
$Window.Close();
})


# Click Event Handler for ButtonGetService
$ButtonGetService = $Window.FindName("ButtonGetService")
$ButtonGetService.add_Click.Invoke({
$ComputerName = $TextboxInput.text.Trim()
try{
Get-Service -ComputerName $computerName | Out-GridView -Title "Get-Service on
$ComputerName"
}catch{[System.Windows.MessageBox]::Show($_.exception.message,"Error"),[System.Windows.MessageBoxButton]::OK,[System.]}
})

# Open the Window
$Window.ShowDialog() | Out-Null


# Ensures that the script won't automatically close, will only close when the User decides.
powershell -noexit