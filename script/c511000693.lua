--Hand Control
function c511000693.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511000693.target)
	e1:SetOperation(c511000693.operation)
	c:RegisterEffect(e1)
end
function c511000693.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,564)
	local ac=Duel.AnnounceCard(tp)
	Duel.SetTargetParam(ac)
	e:GetHandler():SetHint(CHINT_CARD,ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD)
end
function c511000693.operation(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,0,LOCATION_HAND,nil,ac)
	local tc=g:GetFirst()
	if tc then
		if tc:IsType(TYPE_SPELL) or tc:IsType(TYPE_TRAP) then
			local te=tc:GetActivateEffect()
			if not te then return end
			if (cost and not cost(te,1-tp,eg,ep,ev,re,r,rp,0)) or (target and not target(te,1-tp,eg,ep,ev,re,r,rp,0)) then return end
			Duel.MoveToField(tc,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
			Duel.Hint(HINT_CARD,0,tc:GetCode())
			Duel.ClearTargetCard()
			local cost=te:GetCost()
			if cost then cost(e,1-tp,eg,ep,ev,re,r,rp,1) end
			local tar=te:GetTarget()
			if tar then tar(e,1-tp,eg,ep,ev,re,r,rp,1) end
			local op=te:GetOperation()
			if op then op(e,1-tp,eg,ep,ev,re,r,rp,1) end
			if not (tc:IsType(TYPE_CONTINUOUS) or tc:IsType(TYPE_FIELD) or tc:IsType(TYPE_EQUIP)) then
				Duel.SendtoGrave(tc,REASON_EFFECT)
			end
		else
			if tc:IsSummonable(true,nil) then
				Duel.Summon(1-tp,tc,true,nil)
			end
		end
	end
end