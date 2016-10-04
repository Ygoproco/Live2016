--Numeron Network
function c95000023.initial_effect(c)
    --activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(2)
	e2:SetValue(c95000023.valcon)
	c:RegisterEffect(e2)
	--activate 2
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(95000023,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c95000023.accon)
	e3:SetCost(c95000023.accost)
	e3:SetOperation(c95000023.acop)
	c:RegisterEffect(e3)
end
c95000023.mark=0
function c95000023.valcon(e,re,r,rp)
    return bit.band(r,REASON_EFFECT)~=0
end
function c95000023.accon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)<=1
end
function c95000023.cfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave() and c:CheckActivateEffect(false,false,false)~=nil
end
function c95000023.accost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95000023.cfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c95000023.cfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	Duel.SetTargetCard(g:GetFirst())
end
function c95000023.acop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc then
		local te=tc:CheckActivateEffect(false,false,false)
		if not te then return end
		e:SetCategory(te:GetCategory())
		e:SetProperty(te:GetProperty())
		local co=te:GetCost()
		local tg=te:GetTarget()
		local op=te:GetOperation()
		if co then co(e,tp,eg,ep,ev,re,r,rp,1) end
		if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
end
