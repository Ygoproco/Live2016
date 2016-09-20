--呪い移し
function c511000920.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c511000920.condition)
	e1:SetTarget(c511000920.target)
	e1:SetOperation(c511000920.activate)
	c:RegisterEffect(e1)
end
function c511000920.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev) and ep~=tp
end
function c511000920.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c511000920.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
	local c=e:GetHandler()
	local tc=re:GetHandler()
	local tpe=tc:GetType()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetValue(tpe)
	e1:SetReset(RESET_EVENT+0x1fc0000)
	c:RegisterEffect(e1)
	local te=tc:GetActivateEffect()
	local tg=te:GetTarget()
	local op=te:GetOperation()
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	Duel.ClearTargetCard()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
	Duel.BreakEffect()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end 
	if tc:IsType(TYPE_EQUIP+TYPE_CONTINUOUS) then
		local code=tc:GetOriginalCode()
		c:CopyEffect(code,RESET_EVENT+0x1fc0000,1)
		c:CancelToGrave()
	end
	if bit.band(tpe,TYPE_FIELD)~=0 then
		local of=Duel.GetFieldCard(1-tp,LOCATION_SZONE,5)
		if of then Duel.Destroy(of,REASON_RULE) end
		of=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
		if of and Duel.Destroy(of,REASON_RULE)==0 then Duel.SendtoGrave(tc,REASON_RULE) end
		Duel.MoveSequence(tc,5)
	end
end
