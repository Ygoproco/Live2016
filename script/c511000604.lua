--Enemy Controller (Anime)
function c511000604.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511000604.target)
	e1:SetOperation(c511000604.activate)
	c:RegisterEffect(e1)
end
function c511000604.filter(c,tp)
	return c:IsDestructable() or (Duel.CheckLPCost(tp,1000) and c:IsReleasableByEffect())
end
function c511000604.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and chkc:GetControler()~=tp and c511000604.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c511000604.filter,tp,0,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c511000604.filter,tp,0,LOCATION_MZONE,1,1,nil,tp)
end
function c511000604.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local a=tc:IsDestructable()
	local b=Duel.CheckLPCost(tp,1000) and tc:IsReleasableByEffect()
	local op=2
	if tc:IsRelateToEffect(e) then
		if a and b then
			op=Duel.SelectOption(tp,aux.Stringid(698785,0),aux.Stringid(63014935,2))
		elseif a then
			Duel.SelectOption(tp,aux.Stringid(698785,0))
			op=0
		elseif b then
			Duel.SelectOption(tp,aux.Stringid(63014935,2))
			op=1
		end
		if op==0 then
			Duel.Destroy(tc,REASON_EFFECT)
		else
			Duel.PayLPCost(tp,1000)
			Duel.Release(tc,REASON_EFFECT)
		end
	end
end
