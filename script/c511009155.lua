--Performapal Pyro Lobster
function c511009155.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(93543806,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c511009155.lvtg)
	e1:SetOperation(c511009155.lvop)
	c:RegisterEffect(e1)
	
end
function c511009155.filter1(c,tp)
	return c:IsLevelAbove(1) and c:IsSetCard(0x9f)
		and Duel.IsExistingTarget(c511009155.filter2,tp,LOCATION_GRAVE,0,1,c,c:GetLevel())
end
function c511009155.filter2(c,lvl)
	return c:IsLevelAbove(1) and c:IsSetCard(0x9f) and (c:GetLevel()+lvl)<=12
end


function c511009155.filter(c)
	return c:IsFaceup() and c:IsLevelAbove(1)
end
function c511009155.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c511009155.filter1,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g1=Duel.SelectMatchingCard(tp,c511009155.filter1,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g2=Duel.SelectMatchingCard(tp,c511009155.filter2,tp,LOCATION_GRAVE,0,1,1,g1:GetFirst(),g1:GetFirst():GetLevel())
	local lvl=g1:GetFirst():GetLevel()+g2:GetFirst():GetLevel()
	Duel.SelectTarget(tp,c511009155.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,lvl)
	e:SetLabel(lvl)
end
function c511009155.lvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end
