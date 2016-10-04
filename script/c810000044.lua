-- Soul Guide
-- scripted by: UnknownGuest
function c810000044.initial_effect(c)
	-- recover
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c810000044.cost)
	e1:SetTarget(c810000044.target)
	e1:SetOperation(c810000044.activate)
	c:RegisterEffect(e1)
end
function c810000044.filter(c,tp)
	return Duel.IsExistingMatchingCard(c810000044.filter2,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function c810000044.filter2(c,code)
	return c:IsType(TYPE_MONSTER) and c:IsCode(code) and c:IsAbleToHand()
end
function c810000044.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c810000044.filter,1,nil,tp) end
	local sg=Duel.SelectReleaseGroup(tp,c810000044.filter,1,1,nil,tp)
	local tc=sg:GetFirst()
	e:SetLabelObject(tc)
	local atk=tc:GetAttack()
	local def=tc:GetDefense()
	Duel.Release(tc,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(810000044,0))
	local sel=Duel.SelectOption(tp,aux.Stringid(810000044,1),aux.Stringid(810000044,2))
	if sel==0 then e:SetLabel(atk)
	else e:SetLabel(def) end
end
function c810000044.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tc=e:GetLabelObject()
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(e:GetLabel())
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c810000044.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Recover(p,d,REASON_EFFECT)>0 and tc then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c810000044.filter2,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode())
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
