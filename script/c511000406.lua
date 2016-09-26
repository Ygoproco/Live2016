--天使の手鏡
function c511000406.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c511000406.tgcon)
	e1:SetTarget(c511000406.tgtg)
	e1:SetOperation(c511000406.tgop)
	c:RegisterEffect(e1)
end
function c511000406.tgcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasType(EFFECT_TYPE_ACTIVATE) or not re:IsActiveType(TYPE_TRAP)
		or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or g:GetCount()~=1 then return false end
	local tc=g:GetFirst()
	e:SetLabelObject(tc)
	return tc:IsLocation(LOCATION_MZONE)
end
function c511000406.filter(c,re,rp,tf,ceg,cep,cev,cre,cr,crp)
	return tf(re,rp,ceg,cep,cev,cre,cr,crp,0,c)
end
function c511000406.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		if chkc then return false end
	local tf=re:GetTarget()
	if chk==0 then return Duel.IsExistingTarget(c511000406.filter,tp,0,LOCATION_MZONE,1,nil,re,rp,tf) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c511000406.filter,tp,0,LOCATION_MZONE,1,1,nil,re,rp,tf)
end
function c511000406.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tf=re:GetTarget()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tf(re,rp,nil,nil,nil,nil,nil,nil,0,tc) then
		local g=Group.FromCards(tc)
		Duel.ChangeTargetCard(ev,g)
	end
end
