--Parasite Magic
function c511009338.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1c0)
	e1:SetCondition(c511009338.condition)
	e1:SetTarget(c511009338.target)
	e1:SetOperation(c511009338.activate)
	c:RegisterEffect(e1)
end
--OCG Parasite collection
c511009338.collection={
[0]=true;
}
function c511009338.filter(c)
	return c:IsFaceup() and (c511009338.collection[c:GetCode()] or c:IsSetCard(0x410))
end
function c511009338.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c511009338.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c511009338.acfilter(c,tp)
	return c:IsType(TYPE_SPELL) and c:IsSSetable(true) and (c:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
end
function c511009338.target(e,tp,eg,ep,ev,re,r,rp,chk)
if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_GRAVE) and c511009338.acfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c511009338.acfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(511000770,1))
	local g=Duel.SelectTarget(tp,c511009338.acfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function c511009338.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and (tc:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0) then
		local tpe=tc:GetType()
		local te=tc:GetActivateEffect()
		local tg=te:GetTarget()
		local co=te:GetCost()
		local op=te:GetOperation()
		e:SetCategory(te:GetCategory())
		e:SetProperty(te:GetProperty())
		Duel.ClearTargetCard()
		if bit.band(tpe,TYPE_FIELD)~=0 then
			local of=Duel.GetFieldCard(1-tp,LOCATION_SZONE,5)
			if of then Duel.Destroy(of,REASON_RULE) end
			of=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
			if of and Duel.Destroy(of,REASON_RULE)==0 then Duel.SendtoGrave(tc,REASON_RULE) end
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		Duel.Hint(HINT_CARD,0,tc:GetCode())
		tc:CreateEffectRelation(te)
		if bit.band(tpe,TYPE_EQUIP+TYPE_CONTINUOUS+TYPE_FIELD)==0 then
			tc:CancelToGrave(false)
		end
		if co then co(te,tp,eg,ep,ev,re,r,rp,1) end
		if tg then tg(te,tp,eg,ep,ev,re,r,rp,1) end
		Duel.BreakEffect()
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		if g then
			local etc=g:GetFirst()
			while etc do
				etc:CreateEffectRelation(te)
				etc=g:GetNext()
			end
		end
		if op then op(te,tp,eg,ep,ev,re,r,rp) end
		tc:ReleaseEffectRelation(te)
		if etc then	
			etc=g:GetFirst()
			while etc do
				etc:ReleaseEffectRelation(te)
				etc=g:GetNext()
			end
		end
	end
end
