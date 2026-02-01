if not getgenv().UmarHub_Loader then return end

-- SAFE VISIBLE PROOF (no kick)
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Umar Hub",
    Text = "Payload executed successfully",
    Duration = 5
})
