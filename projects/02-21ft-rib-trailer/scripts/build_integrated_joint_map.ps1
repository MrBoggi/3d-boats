Add-Type -AssemblyName System.Drawing

$project = Split-Path -Parent $PSScriptRoot
$output = Join-Path $project '3mf/integrated_joint_tests/assembly_map.png'
$groups = @(
    @{ Number = '1'; Note = 'V-JOINT'; Parts = @(
        @('fit_v_front', 'OVERDEL'), @('fit_v_rear', 'UNDERDEL')) },
    @{ Number = '2'; Note = 'FRONT NODE - BOTH UPPER PARTS ON THE SAME LOWER PART'; Parts = @(
        @('fit_front_v', 'OVERDEL V'), @('fit_front_crossmember', 'UNDERDEL'),
        @('fit_front_rail', 'OVERDEL VANGE')) },
    @{ Number = '3'; Note = 'RAIL SPLICE'; Parts = @(
        @('fit_splice_front', 'OVERDEL'), @('fit_splice_rear', 'UNDERDEL')) },
    @{ Number = '4'; Note = 'MIDDLE CROSSMEMBER'; Parts = @(
        @('fit_mid_rail', 'OVERDEL'), @('fit_mid_crossmember', 'UNDERDEL')) },
    @{ Number = '5'; Note = 'REAR CROSSMEMBER'; Parts = @(
        @('fit_rear_rail', 'OVERDEL'), @('fit_rear_crossmember', 'UNDERDEL')) }
)

$width = 1800
$rowHeight = 330
$height = 150 + $groups.Count * $rowHeight
$bitmap = New-Object System.Drawing.Bitmap($width, $height)
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)
$graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$graphics.Clear([System.Drawing.Color]::FromArgb(249, 248, 239))

$titleFont = New-Object System.Drawing.Font('Segoe UI', 32, [System.Drawing.FontStyle]::Bold)
$groupFont = New-Object System.Drawing.Font('Segoe UI', 38, [System.Drawing.FontStyle]::Bold)
$noteFont = New-Object System.Drawing.Font('Segoe UI', 20, [System.Drawing.FontStyle]::Bold)
$labelFont = New-Object System.Drawing.Font('Consolas', 15, [System.Drawing.FontStyle]::Regular)
$roleFont = New-Object System.Drawing.Font('Segoe UI', 16, [System.Drawing.FontStyle]::Bold)
$dark = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(35, 48, 40))
$green = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(42, 116, 67))
$panel = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(236, 239, 225))
$line = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(112, 126, 105), 3)

$graphics.DrawString('PART MAP - INTEGRATED FRAME JOINTS', $titleFont, $dark, 55, 38)
$graphics.DrawString('Same engraved number = parts belong together', $noteFont, $green, 58, 92)

for ($row = 0; $row -lt $groups.Count; $row++) {
    $group = $groups[$row]
    $y = 135 + $row * $rowHeight
    $graphics.FillRectangle($panel, 35, $y, $width - 70, $rowHeight - 18)
    $graphics.DrawString($group.Number, $groupFont, $green, 65, $y + 95)
    $graphics.DrawString($group.Note, $noteFont, $dark, 150, $y + 18)

    $count = $group.Parts.Count
    $slotWidth = [Math]::Floor(1500 / $count)
    for ($column = 0; $column -lt $count; $column++) {
        $part = $group.Parts[$column][0]
        $role = $group.Parts[$column][1]
        $imagePath = Join-Path $project ("map_{0}.png" -f $part)
        $image = [System.Drawing.Image]::FromFile($imagePath)
        $x = 170 + $column * $slotWidth
        $drawWidth = [Math]::Min(430, $slotWidth - 25)
        $drawHeight = 205
        $graphics.DrawImage($image, $x, $y + 58, $drawWidth, $drawHeight)
        $image.Dispose()
        $graphics.DrawString($role, $roleFont, $green, $x + 5, $y + 260)
        $graphics.DrawString($part, $labelFont, $dark, $x + 5, $y + 290)
    }
}

$bitmap.Save($output, [System.Drawing.Imaging.ImageFormat]::Png)
$line.Dispose()
$panel.Dispose()
$green.Dispose()
$dark.Dispose()
$labelFont.Dispose()
$roleFont.Dispose()
$noteFont.Dispose()
$groupFont.Dispose()
$titleFont.Dispose()
$graphics.Dispose()
$bitmap.Dispose()
Write-Output $output
