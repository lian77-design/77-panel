-- =====================================================
-- 77 PANEL - DELTA MOBILE (CORRIGIDO v4)
-- Desenvolvedor: Julian
-- Versão: 1.0.0 (Interface v4.0.0)
-- Tema: Roxo Escuro / Preto / Lilás
-- ESP: SelectionBox (bordas roxas, meio invisível)
-- =====================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- =====================================================
-- CONFIGURAÇÕES DE CORES
-- =====================================================

local Cores = {
    FundoPrincipal = Color3.fromRGB(22, 10, 43),
    FundoSecundario = Color3.fromRGB(30, 15, 55),
    RoxoSecundario = Color3.fromRGB(91, 33, 182),
    RoxoEscuro = Color3.fromRGB(75, 0, 130),        -- Roxo escuro das bordas do ESP
    LilasDestaque = Color3.fromRGB(168, 85, 247),
    TextoBranco = Color3.fromRGB(240, 240, 240),
    TextoCinza = Color3.fromRGB(180, 180, 180),
    Verde = Color3.fromRGB(0, 255, 100),
    Vermelho = Color3.fromRGB(255, 60, 60)
}

-- =====================================================
-- VARIÁVEIS DE ESTADO
-- =====================================================

local PainelAberto = true
local ESPAtivo = false
local AlvoSelecionado = nil
local Espectando = false
local JogadorEspectado = nil
local PingAtivo = false

-- =====================================================
-- FUNÇÕES AUXILIARES
-- =====================================================

local function CriarInstancia(Classe, Propriedades)
    local Instancia = Instance.new(Classe)
    for Prop, Valor in pairs(Propriedades) do
        Instancia[Prop] = Valor
    end
    return Instancia
end

local function Arredondar(Objeto, Raio)
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, Raio)
    UICorner.Parent = Objeto
    return UICorner
end

local function AdicionarSombra(Objeto)
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(0, 0, 0)
    UIStroke.Thickness = 1
    UIStroke.Transparency = 0.5
    UIStroke.Parent = Objeto
    return UIStroke
end

-- Fallback de CoreGui
local function GetParentGui()
    local sucesso = pcall(function()
        local teste = Instance.new("Folder")
        teste.Parent = CoreGui
        teste:Destroy()
    end)
    if sucesso then
        return CoreGui
    else
        return LocalPlayer:WaitForChild("PlayerGui")
    end
end

-- =====================================================
-- CRIAÇÃO DA INTERFACE PRINCIPAL
-- =====================================================

local ParentGui = GetParentGui()

if ParentGui:FindFirstChild("77Panel") then
    ParentGui:FindFirstChild("77Panel"):Destroy()
end

local ScreenGui = CriarInstancia("ScreenGui", {
    Name = "77Panel",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    Parent = ParentGui
})

local FundoEscuro = CriarInstancia("Frame", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundColor3 = Color3.fromRGB(0, 0, 0),
    BackgroundTransparency = 0.5,
    Visible = false,
    Parent = ScreenGui
})

local JanelaPrincipal = CriarInstancia("Frame", {
    Name = "JanelaPrincipal",
    Size = UDim2.new(0, 520, 0, 380),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = Cores.FundoPrincipal,
    BackgroundTransparency = 0.15,
    BorderSizePixel = 0,
    Parent = ScreenGui
})
Arredondar(JanelaPrincipal, 12)
AdicionarSombra(JanelaPrincipal)

local Blur = Instance.new("BlurEffect")
Blur.Size = 0
Blur.Parent = game.Lighting

-- =====================================================
-- BARRA SUPERIOR
-- =====================================================

local BarraSuperior = CriarInstancia("Frame", {
    Name = "BarraSuperior",
    Size = UDim2.new(1, 0, 0, 42),
    BackgroundColor3 = Cores.FundoPrincipal,
    BackgroundTransparency = 0.3,
    BorderSizePixel = 0,
    Parent = JanelaPrincipal
})
Arredondar(BarraSuperior, 12)

local BarraSuperiorFix = CriarInstancia("Frame", {
    Size = UDim2.new(1, 0, 0, 21),
    Position = UDim2.new(0, 0, 0.5, 0),
    BackgroundColor3 = Cores.FundoPrincipal,
    BackgroundTransparency = 0.3,
    BorderSizePixel = 0,
    Parent = BarraSuperior
})

local Titulo = CriarInstancia("TextLabel", {
    Name = "Titulo",
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text = "77 Panel",
    TextColor3 = Cores.TextoBranco,
    Font = Enum.Font.GothamBold,
    TextSize = 18,
    Parent = BarraSuperior
})

local VersaoLabel = CriarInstancia("TextLabel", {
    Name = "Versao",
    Size = UDim2.new(0, 70, 0, 25),
    Position = UDim2.new(0, 12, 0.5, -12),
    BackgroundTransparency = 1,
    Text = "v4.0.0",
    TextColor3 = Cores.LilasDestaque,
    Font = Enum.Font.GothamBold,
    TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = BarraSuperior
})

-- =====================================================
-- MENU LATERAL
-- =====================================================

local MenuLateral = CriarInstancia("Frame", {
    Name = "MenuLateral",
    Size = UDim2.new(0, 120, 1, -42),
    Position = UDim2.new(0, 0, 0, 42),
    BackgroundColor3 = Cores.FundoPrincipal,
    BackgroundTransparency = 0.2,
    BorderSizePixel = 0,
    Parent = JanelaPrincipal
})

local ListaMenu = CriarInstancia("UIListLayout", {
    Padding = UDim.new(0, 4),
    SortOrder = Enum.SortOrder.LayoutOrder,
    Parent = MenuLateral
})

local PaddingMenu = CriarInstancia("UIPadding", {
    PaddingTop = UDim.new(0, 8),
    PaddingLeft = UDim.new(0, 8),
    PaddingRight = UDim.new(0, 8),
    Parent = MenuLateral
})

local Categorias = {"Home", "Target", "Misc", "About"}
local BotoesMenu = {}

local AreaPrincipal = CriarInstancia("Frame", {
    Name = "AreaPrincipal",
    Size = UDim2.new(1, -120, 1, -42),
    Position = UDim2.new(0, 120, 0, 42),
    BackgroundColor3 = Cores.FundoPrincipal,
    BackgroundTransparency = 0.4,
    BorderSizePixel = 0,
    Parent = JanelaPrincipal
})

local MarcaDagua = CriarInstancia("TextLabel", {
    Name = "MarcaDagua",
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text = "77",
    TextColor3 = Cores.LilasDestaque,
    TextTransparency = 0.9,
    Font = Enum.Font.GothamBold,
    TextSize = 200,
    ZIndex = 1,
    Parent = AreaPrincipal
})

-- =====================================================
-- FUNÇÕES DO ESP (SelectionBox - BORDAS ROXAS)
-- =====================================================

local function AplicarESP(player)
    if player == LocalPlayer then return end
    if not player.Character then return end
    
    local root = player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    if root:FindFirstChild("77ESPBox") then return end
    
    -- SelectionBox: desenha APENAS as bordas
    -- Sem preenchimento nenhum, apenas o contorno do quadrado
    local box = Instance.new("SelectionBox")
    box.Name = "77ESPBox"
    box.Adornee = root
    box.LineThickness = 0.05           -- Espessura da linha (0.05 = fina e elegante)
    box.Color3 = Cores.RoxoEscuro      -- Cor das BORDAS (roxo escuro)
    box.SurfaceColor3 = Cores.RoxoEscuro
    box.SurfaceTransparency = 1        -- Meio 100% invisível
    box.Transparency = 1               -- Sem qualquer preenchimento
    box.Visible = true
    box.Parent = root
    
    -- BillboardGui com o nome e distância
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "77ESPName"
    billboard.Size = UDim2.new(0, 130, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 0, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = root
    
    local text = Instance.new("TextLabel")
    text.Name = "NomeLabel"
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.TextColor3 = Cores.LilasDestaque
    text.Font = Enum.Font.GothamBold
    text.TextSize = 12
    text.TextStrokeTransparency = 0.3
    text.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    text.Text = ""
    text.Parent = billboard
end

local function AtivarESP()
    for _, player in pairs(Players:GetPlayers()) do
        AplicarESP(player)
    end

    task.spawn(function()
        while ESPAtivo do
            task.wait(0.1)
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local root = player.Character:FindFirstChild("HumanoidRootPart")
                    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if root and myRoot then
                        local billboard = root:FindFirstChild("77ESPName")
                        if billboard then
                            local text = billboard:FindFirstChild("NomeLabel")
                            if text then
                                local dist = math.floor((myRoot.Position - root.Position).Magnitude)
                                text.Text = player.Name .. " [" .. dist .. "m]"
                            end
                        end
                    end
                end
            end
        end
    end)
end

local function DesativarESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local box = root:FindFirstChild("77ESPBox")
                if box then box:Destroy() end
                local billboard = root:FindFirstChild("77ESPName")
                if billboard then billboard:Destroy() end
            end
        end
    end
end

-- Aplica ESP em jogadores que entrarem depois
Players.PlayerAdded:Connect(function(player)
    if ESPAtivo then
        player.CharacterAdded:Connect(function()
            task.wait(1)
            if ESPAtivo then
                AplicarESP(player)
            end
        end)
    end
end)

-- =====================================================
-- FUNÇÃO TROCAR ABA
-- =====================================================

local function TrocarAba(NomeAba)
    for _, botao in pairs(BotoesMenu) do
        if botao.Name == NomeAba then
            botao.BackgroundColor3 = Cores.RoxoSecundario
            botao.TextColor3 = Cores.TextoBranco
        else
            botao.BackgroundColor3 = Cores.FundoPrincipal
            botao.TextColor3 = Cores.TextoCinza
        end
    end

    for _, child in pairs(AreaPrincipal:GetChildren()) do
        if (child:IsA("Frame") or child:IsA("ScrollingFrame") or child:IsA("TextLabel"))
           and child.Name ~= "MarcaDagua" then
            child:Destroy()
        end
    end

    PingAtivo = false

    if Espectando then
        Espectando = false
        JogadorEspectado = nil
        if LocalPlayer.Character then
            local cam = workspace.CurrentCamera
            cam.CameraSubject = LocalPlayer.Character:FindFirstChild("Humanoid")
            cam.CameraType = Enum.CameraType.Custom
        end
    end

    if NomeAba == "Home" then
        local ContainerHome = CriarInstancia("Frame", {
            Size = UDim2.new(1, -24, 1, -24),
            Position = UDim2.new(0, 12, 0, 12),
            BackgroundTransparency = 1,
            ZIndex = 2,
            Parent = AreaPrincipal
        })

        local Cartao = CriarInstancia("Frame", {
            Size = UDim2.new(1, 0, 0, 140),
            BackgroundColor3 = Cores.FundoPrincipal,
            BackgroundTransparency = 0.3,
            BorderSizePixel = 0,
            ZIndex = 2,
            Parent = ContainerHome
        })
        Arredondar(Cartao, 10)

        local Avatar = CriarInstancia("ImageLabel", {
            Size = UDim2.new(0, 60, 0, 60),
            Position = UDim2.new(0, 15, 0, 15),
            BackgroundColor3 = Cores.RoxoSecundario,
            BorderSizePixel = 0,
            ZIndex = 3,
            Parent = Cartao
        })
        local AvatarCorner = Instance.new("UICorner")
        AvatarCorner.CornerRadius = UDim.new(1, 0)
        AvatarCorner.Parent = Avatar

        pcall(function()
            Avatar.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
        end)

        CriarInstancia("TextLabel", {
            Size = UDim2.new(1, -90, 0, 24),
            Position = UDim2.new(0, 90, 0, 15),
            BackgroundTransparency = 1,
            Text = "Olá! " .. LocalPlayer.Name,
            TextColor3 = Cores.TextoBranco,
            Font = Enum.Font.GothamBold,
            TextSize = 16,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 3,
            Parent = Cartao
        })

        CriarInstancia("TextLabel", {
            Size = UDim2.new(1, -90, 0, 16),
            Position = UDim2.new(0, 90, 0, 42),
            BackgroundTransparency = 1,
            Text = "Pressione [B] para abrir/fechar",
            TextColor3 = Cores.TextoCinza,
            Font = Enum.Font.Gotham,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 3,
            Parent = Cartao
        })

        local PingLabel = CriarInstancia("TextLabel", {
            Size = UDim2.new(0, 180, 0, 16),
            Position = UDim2.new(0, 90, 0, 65),
            BackgroundTransparency = 1,
            Text = "Ping: Carregando...",
            TextColor3 = Cores.Verde,
            Font = Enum.Font.Gotham,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 3,
            Parent = Cartao
        })

        local UsersLabel = CriarInstancia("TextLabel", {
            Size = UDim2.new(0, 180, 0, 16),
            Position = UDim2.new(0, 90, 0, 85),
            BackgroundTransparency = 1,
            Text = "Users: " .. #Players:GetPlayers(),
            TextColor3 = Cores.TextoBranco,
            Font = Enum.Font.Gotham,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 3,
            Parent = Cartao
        })

        local OnlineLabel = CriarInstancia("TextLabel", {
            Size = UDim2.new(0, 180, 0, 16),
            Position = UDim2.new(0, 90, 0, 105),
            BackgroundTransparency = 1,
            Text = "Online: 1",
            TextColor3 = Cores.TextoBranco,
            Font = Enum.Font.Gotham,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 3,
            Parent = Cartao
        })

        local DataLabel = CriarInstancia("TextLabel", {
            Size = UDim2.new(0, 180, 0, 16),
            Position = UDim2.new(0, 90, 0, 125),
            BackgroundTransparency = 1,
            Text = "Date: " .. os.date("%d/%m/%Y - %H:%M"),
            TextColor3 = Cores.TextoBranco,
            Font = Enum.Font.Gotham,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 3,
            Parent = Cartao
        })

        PingAtivo = true
        task.spawn(function()
            while PingAtivo do
                task.wait(1)
                if not PingLabel or not PingLabel.Parent then
                    PingAtivo = false
                    break
                end
                local ping = math.floor(LocalPlayer:GetNetworkPing() * 1000)
                PingLabel.Text = "Ping: " .. ping
                DataLabel.Text = "Date: " .. os.date("%d/%m/%Y - %H:%M")
                UsersLabel.Text = "Users: " .. #Players:GetPlayers()
                OnlineLabel.Text = "Online: " .. #Players:GetPlayers()
            end
        end)

    elseif NomeAba == "Target" then
        local ContainerTarget = CriarInstancia("Frame", {
            Size = UDim2.new(1, -24, 1, -24),
            Position = UDim2.new(0, 12, 0, 12),
            BackgroundTransparency = 1,
            ZIndex = 2,
            Parent = AreaPrincipal
        })

        local CampoPesquisa = CriarInstancia("TextBox", {
            Size = UDim2.new(1, 0, 0, 38),
            BackgroundColor3 = Cores.FundoPrincipal,
            BackgroundTransparency = 0.3,
            Text = "",
            PlaceholderText = "Pesquisar @username...",
            TextColor3 = Cores.TextoBranco,
            PlaceholderColor3 = Cores.TextoCinza,
            Font = Enum.Font.Gotham,
            TextSize = 14,
            ZIndex = 3,
            Parent = ContainerTarget
        })
        Arredondar(CampoPesquisa, 8)

        local BotaoTP = CriarInstancia("TextButton", {
            Size = UDim2.new(0.48, 0, 0, 38),
            Position = UDim2.new(0, 0, 0, 48),
            BackgroundColor3 = Cores.RoxoSecundario,
            Text = "TELEPORT",
            TextColor3 = Cores.TextoBranco,
            Font = Enum.Font.GothamBold,
            TextSize = 12,
            ZIndex = 3,
            Parent = ContainerTarget
        })
        Arredondar(BotaoTP, 8)

        local BotaoEspectar = CriarInstancia("TextButton", {
            Size = UDim2.new(0.48, 0, 0, 38),
            Position = UDim2.new(0.52, 0, 0, 48),
            BackgroundColor3 = Cores.RoxoSecundario,
            Text = "ESPECTAR",
            TextColor3 = Cores.TextoBranco,
            Font = Enum.Font.GothamBold,
            TextSize = 12,
            ZIndex = 3,
            Parent = ContainerTarget
        })
        Arredondar(BotaoEspectar, 8)

        local ScrollJogadores = CriarInstancia("ScrollingFrame", {
            Size = UDim2.new(1, 0, 1, -100),
            Position = UDim2.new(0, 0, 0, 96),
            BackgroundColor3 = Cores.FundoPrincipal,
            BackgroundTransparency = 0.5,
            BorderSizePixel = 0,
            ScrollBarThickness = 4,
            ZIndex = 3,
            Parent = ContainerTarget
        })
        Arredondar(ScrollJogadores, 8)

        local LayoutJogadores = CriarInstancia("UIListLayout", {
            Padding = UDim.new(0, 4),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = ScrollJogadores
        })

        local function AtualizarLista(Filtro)
            Filtro = Filtro or ""
            for _, child in pairs(ScrollJogadores:GetChildren()) do
                if child:IsA("TextButton") then child:Destroy() end
            end

            local encontrados = {}
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    local match = false
                    if Filtro == "" then
                        match = true
                    elseif #Filtro >= 3 then
                        if string.find(string.lower(player.Name), string.lower(Filtro)) then
                            match = true
                        end
                    else
                        if string.sub(string.lower(player.Name), 1, #Filtro) == string.lower(Filtro) then
                            match = true
                        end
                    end

                    if match then
                        table.insert(encontrados, player)
                        local BotaoPlayer = CriarInstancia("TextButton", {
                            Size = UDim2.new(1, 0, 0, 34),
                            BackgroundColor3 = Cores.FundoPrincipal,
                            BackgroundTransparency = 0.2,
                            Text = player.Name,
                            TextColor3 = Cores.TextoBranco,
                            Font = Enum.Font.Gotham,
                            TextSize = 12,
                            ZIndex = 4,
                            Parent = ScrollJogadores
                        })
                        Arredondar(BotaoPlayer, 6)

                        BotaoPlayer.MouseButton1Click:Connect(function()
                            AlvoSelecionado = player
                            CampoPesquisa.Text = player.Name
                            for _, btn in pairs(ScrollJogadores:GetChildren()) do
                                if btn:IsA("TextButton") then
                                    btn.BackgroundColor3 = Cores.FundoPrincipal
                                end
                            end
                            BotaoPlayer.BackgroundColor3 = Cores.RoxoSecundario
                        end)
                    end
                end
            end

            if #encontrados == 1 and Filtro ~= "" then
                AlvoSelecionado = encontrados[1]
            end
        end
        AtualizarLista()

        CampoPesquisa:GetPropertyChangedSignal("Text"):Connect(function()
            AtualizarLista(CampoPesquisa.Text)
        end)

        Players.PlayerAdded:Connect(function() AtualizarLista(CampoPesquisa.Text) end)
        Players.PlayerRemoving:Connect(function() AtualizarLista(CampoPesquisa.Text) end)

        BotaoTP.MouseButton1Click:Connect(function()
            local alvo = AlvoSelecionado
            if not alvo and CampoPesquisa.Text ~= "" then
                alvo = Players:FindFirstChild(CampoPesquisa.Text)
            end

            if not alvo then return end

            if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.CharacterAdded:Wait()
            end

            if not alvo.Character or not alvo.Character:FindFirstChild("HumanoidRootPart") then
                alvo.CharacterAdded:Wait()
            end

            local rootAlvo = alvo.Character:FindFirstChild("HumanoidRootPart")
            local rootLocal = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

            if rootAlvo and rootLocal then
                rootLocal.CFrame = rootAlvo.CFrame + Vector3.new(0, 3, 0)
            end
        end)

        BotaoEspectar.MouseButton1Click:Connect(function()
            local alvo = AlvoSelecionado
            if not alvo and CampoPesquisa.Text ~= "" then
                alvo = Players:FindFirstChild(CampoPesquisa.Text)
            end

            if not alvo then return end

            if Espectando and JogadorEspectado == alvo then
                Espectando = false
                JogadorEspectado = nil
                BotaoEspectar.Text = "ESPECTAR"
                BotaoEspectar.BackgroundColor3 = Cores.RoxoSecundario
                if LocalPlayer.Character then
                    local cam = workspace.CurrentCamera
                    cam.CameraSubject = LocalPlayer.Character:FindFirstChild("Humanoid")
                    cam.CameraType = Enum.CameraType.Custom
                end
            else
                Espectando = true
                JogadorEspectado = alvo
                BotaoEspectar.Text = "PARAR"
                BotaoEspectar.BackgroundColor3 = Cores.LilasDestaque

                task.spawn(function()
                    while Espectando and JogadorEspectado and JogadorEspectado.Character do
                        task.wait(0.1)
                        local cam = workspace.CurrentCamera
                        local humanoid = JogadorEspectado.Character:FindFirstChild("Humanoid")
                        if humanoid then
                            cam.CameraSubject = humanoid
                            cam.CameraType = Enum.CameraType.Follow
                        else
                            break
                        end
                    end
                    if Espectando then
                        Espectando = false
                        JogadorEspectado = nil
                        if BotaoEspectar and BotaoEspectar.Parent then
                            BotaoEspectar.Text = "ESPECTAR"
                            BotaoEspectar.BackgroundColor3 = Cores.RoxoSecundario
                        end
                        if LocalPlayer.Character then
                            local cam = workspace.CurrentCamera
                            cam.CameraSubject = LocalPlayer.Character:FindFirstChild("Humanoid")
                            cam.CameraType = Enum.CameraType.Custom
                        end
                    end
                end)
            end
        end)

    elseif NomeAba == "Misc" then
        local ContainerMisc = CriarInstancia("Frame", {
            Size = UDim2.new(1, -24, 1, -24),
            Position = UDim2.new(0, 12, 0, 12),
            BackgroundTransparency = 1,
            ZIndex = 2,
            Parent = AreaPrincipal
        })

        local BotaoESP = CriarInstancia("TextButton", {
            Size = UDim2.new(0.5, 0, 0, 42),
            Position = UDim2.new(0.25, 0, 0, 40),
            BackgroundColor3 = Cores.RoxoSecundario,
            Text = "ESP: OFF",
            TextColor3 = Cores.TextoBranco,
            Font = Enum.Font.GothamBold,
            TextSize = 13,
            ZIndex = 3,
            Parent = ContainerMisc
        })
        Arredondar(BotaoESP, 8)

        if ESPAtivo then
            BotaoESP.Text = "ESP: ON"
            BotaoESP.BackgroundColor3 = Cores.LilasDestaque
        end

        BotaoESP.MouseButton1Click:Connect(function()
            ESPAtivo = not ESPAtivo
            if ESPAtivo then
                BotaoESP.Text = "ESP: ON"
                BotaoESP.BackgroundColor3 = Cores.LilasDestaque
                AtivarESP()
            else
                BotaoESP.Text = "ESP: OFF"
                BotaoESP.BackgroundColor3 = Cores.RoxoSecundario
                DesativarESP()
            end
        end)

    elseif NomeAba == "About" then
        local ContainerAbout = CriarInstancia("Frame", {
            Size = UDim2.new(1, -24, 1, -24),
            Position = UDim2.new(0, 12, 0, 12),
            BackgroundTransparency = 1,
            ZIndex = 2,
            Parent = AreaPrincipal
        })

        local InfoAbout = {
            "Developer: Julian",
            "77 Panel",
            "Version: v1.0.0"
        }

        for i, texto in pairs(InfoAbout) do
            CriarInstancia("TextLabel", {
                Size = UDim2.new(1, 0, 0, 34),
                Position = UDim2.new(0, 0, 0, (i-1) * 42),
                BackgroundTransparency = 1,
                Text = texto,
                TextColor3 = Cores.LilasDestaque,
                Font = Enum.Font.GothamBold,
                TextSize = 15,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 3,
                Parent = ContainerAbout
            })
        end
    end
end

-- Criar botões do menu
for _, NomeAba in pairs(Categorias) do
    local Botao = CriarInstancia("TextButton", {
        Name = NomeAba,
        Size = UDim2.new(1, 0, 0, 38),
        BackgroundColor3 = Cores.FundoPrincipal,
        Text = NomeAba,
        TextColor3 = Cores.TextoCinza,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        ZIndex = 3,
        Parent = MenuLateral
    })
    Arredondar(Botao, 8)

    Botao.MouseButton1Click:Connect(function()
        TrocarAba(NomeAba)
    end)

    table.insert(BotoesMenu, Botao)
end

TrocarAba("Home")

-- =====================================================
-- ABRIR/FECHAR (TECLA B)
-- =====================================================

local function AlternarPainel()
    PainelAberto = not PainelAberto
    JanelaPrincipal.Visible = PainelAberto
    FundoEscuro.Visible = PainelAberto

    TweenService:Create(Blur, TweenInfo.new(0.3), {Size = PainelAberto and 15 or 0}):Play()

    if PainelAberto then
        JanelaPrincipal.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(JanelaPrincipal, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 520, 0, 380)
        }):Play()
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.B then
        AlternarPainel()
    end
end)

-- =====================================================
-- BOTÃO FLUTUANTE (ARRASTÁVEL)
-- =====================================================

local BotaoFlutuante = CriarInstancia("TextButton", {
    Size = UDim2.new(0, 45, 0, 45),
    Position = UDim2.new(0, 20, 0.5, -22),
    BackgroundColor3 = Cores.RoxoSecundario,
    Text = "77",
    TextColor3 = Cores.TextoBranco,
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    ZIndex = 10,
    Parent = ScreenGui
})
Arredondar(BotaoFlutuante, 22)
AdicionarSombra(BotaoFlutuante)

local dragging, dragInput, dragStart, startPos

BotaoFlutuante.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
       or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = BotaoFlutuante.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

BotaoFlutuante.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
       or input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        local delta = input.Position - dragStart
        BotaoFlutuante.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

BotaoFlutuante.MouseButton1Click:Connect(function()
    if not dragging then
        AlternarPainel()
    end
end)

-- =====================================================
-- INICIALIZAÇÃO
-- =====================================================

JanelaPrincipal.Visible = false
FundoEscuro.Visible = false
Blur.Size = 0
print("77 Panel carregado! Pressione [J] ou toque no botão 77 para abrir.")
