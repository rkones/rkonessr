Add-Type -AssemblyName PresentationFramework,PresentationCore,WindowsBase

# Set your target date/time
$targetDate = Get-Date "2026-07-31 23:59:59"

function Get-CountdownText {
    param ($target)

    $now = Get-Date
    $timeLeft = $target - $now

    if ($timeLeft.TotalSeconds -le 0) {
        return "Time's up!"
    }

    $days = $timeLeft.Days
    $hours = $timeLeft.Hours.ToString('D2')
    $minutes = $timeLeft.Minutes.ToString('D2')
    $seconds = $timeLeft.Seconds.ToString('D2')

    return "Days: $days  Hours: $hours  Minutes: $minutes  Seconds: $seconds"
}

$window = New-Object System.Windows.Window
$window.Title = 'Countdown Widget'
$window.Width = 320
$window.Height = 140
$window.WindowStartupLocation = 'CenterScreen'
$window.Topmost = $true
$window.WindowStyle = 'None'
$window.AllowsTransparency = $true
$window.Background = [System.Windows.Media.Brushes]::Transparent
$window.ResizeMode = 'NoResize'
$window.ShowInTaskbar = $true

$border = New-Object System.Windows.Controls.Border
$border.CornerRadius = [System.Windows.CornerRadius]::new(16)
$border.Background = [System.Windows.Media.Brushes]::Black
$border.Opacity = 0.80
$border.BorderThickness = [System.Windows.Thickness]::new(1)
$border.BorderBrush = [System.Windows.Media.Brushes]::White
$border.Padding = [System.Windows.Thickness]::new(12)

$panel = New-Object System.Windows.Controls.StackPanel
$panel.Orientation = 'Vertical'
$panel.HorizontalAlignment = 'Center'
$panel.VerticalAlignment = 'Center'
$panel.Margin = [System.Windows.Thickness]::new(4)

$header = New-Object System.Windows.Controls.TextBlock
$header.Text = 'Countdown'
$header.FontSize = 22
$header.FontWeight = 'Bold'
$header.Foreground = [System.Windows.Media.Brushes]::White
$header.HorizontalAlignment = 'Center'
$header.Margin = [System.Windows.Thickness]::new(0,0,0,8)

$timeText = New-Object System.Windows.Controls.TextBlock
$timeText.Text = Get-CountdownText -target $targetDate
$timeText.FontFamily = New-Object System.Windows.Media.FontFamily('Consolas')
$timeText.FontSize = 20
$timeText.Foreground = [System.Windows.Media.Brushes]::LightGreen
$timeText.TextAlignment = 'Center'
$timeText.TextWrapping = 'Wrap'
$timeText.HorizontalAlignment = 'Center'

$footer = New-Object System.Windows.Controls.TextBlock
$footer.Text = "Target: $($targetDate.ToString('yyyy-MM-dd HH:mm:ss'))"
$footer.FontSize = 12
$footer.Foreground = [System.Windows.Media.Brushes]::LightGray
$footer.HorizontalAlignment = 'Center'
$footer.Margin = [System.Windows.Thickness]::new(0,10,0,0)

$panel.Children.Add($header) | Out-Null
$panel.Children.Add($timeText) | Out-Null
$panel.Children.Add($footer) | Out-Null
$border.Child = $panel
$window.Content = $border

# Allow the widget to be dragged around the desktop
$window.MouseLeftButtonDown.Add({
    try { $window.DragMove() } catch { }
})

$timer = New-Object System.Windows.Threading.DispatcherTimer
$timer.Interval = [TimeSpan]::FromSeconds(1)
$timer.Add_Tick({
    $timeText.Text = Get-CountdownText -target $targetDate
})
$timer.Start()

$window.ShowDialog() | Out-Null