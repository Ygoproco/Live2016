--熱血指導王ジャイアントレーナー
function c511002829.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,8,3)
	c:EnableReviveLimit()
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_DAMAGE)
	e1:SetDescription(aux.Stringid(30741334,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c511002829.cost)
	e1:SetTarget(c511002829.target)
	e1:SetOperation(c511002829.operation)
	c:RegisterEffect(e1)
end
function c511002829.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c511002829.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsPlayerCanDraw(1-tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
end
function c511002829.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.ShuffleDeck(tp,REASON_EFFECT)
	Duel.ShuffleDeck(1-tp,REASON_EFFECT)
	local tc1=Duel.GetDecktopGroup(tp,1):GetFirst()
	local tc2=Duel.GetDecktopGroup(1-tp,1):GetFirst()
	Duel.Draw(tp,1,REASON_EFFECT)
	Duel.Draw(1-tp,1,REASON_EFFECT)
	if tc1 and tc2 then
		Duel.ConfirmCards(1-tp,tc1)
		Duel.ConfirmCards(tp,tc2)
		if tc1:IsType(TYPE_MONSTER) and tc2:IsType(TYPE_MONSTER) then
			Duel.BreakEffect()
			if tc1:GetLevel()<tc2:GetLevel() then
				Duel.Damage(tp,800,REASON_EFFECT)
			elseif tc1:GetLevel()>tc2:GetLevel() then
				Duel.Damage(1-tp,800,REASON_EFFECT)
			end
		end
		Duel.BreakEffect()
		local g=Group.CreateGroup()
		g:AddCard(tc1)
		g:AddCard(tc2)
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
