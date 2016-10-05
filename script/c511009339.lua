--Power Parasite
function c511009339.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCondition(c511009339.condition)
	e1:SetTarget(c511009339.target)
	e1:SetOperation(c511009339.activate)
	c:RegisterEffect(e1)
end

function c511009339.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c511009339.eqfilter(c)
	return c:IsCode(511002961)
end
function c511009339.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c511009339.eqfilter,tp,LOCATION_GRAVE,0,1,nil) end
		local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_GRAVE)
end
function c511009339.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if not tc then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(12152769,2))
		local g=Duel.SelectMatchingCard(tp,c511009339.eqfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		local ec=g:GetFirst()
		if ec then
			Duel.HintSelection(g)
			if not Duel.Equip(tp,ec,tc,true) then return end
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(c511009339.eqlimit)
			e1:SetLabelObject(tc)
			ec:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_EQUIP)
			e2:SetProperty(EFFECT_FLAG_OWNER_RELATE+EFFECT_FLAG_IGNORE_IMMUNE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			e2:SetValue(300)
			ec:RegisterEffect(e2)
		end
	end
		
function c511009339.eqlimit(e,c)
	return c==e:GetLabelObject()
end

