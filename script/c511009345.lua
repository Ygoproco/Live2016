--Double Parasitic Rebirth
function c511009345.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCondition(c511009345.condition)
	e1:SetTarget(c511009345.target)
	e1:SetOperation(c511009345.activate)
	c:RegisterEffect(e1)
end

function c511009345.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c511009345.eqfilter(c)
	return c:IsCode(511002961)
end
function c511009345.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_SZONE)>1 or Duel.GetLocationCount(tp,LOCATION_SZONE)>1
		and Duel.IsExistingMatchingCard(c511009345.eqfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,2,nil) end
		-- and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)
		if Duel.GetLocationCount(1-tp,LOCATION_SZONE)>1 and Duel.GetLocationCount(tp,LOCATION_SZONE)>1 then
		local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_GRAVE)
		elseif Duel.GetLocationCount(tp,LOCATION_SZONE)>1 and not Duel.GetLocationCount(1-tp,LOCATION_SZONE)>1 then
		 local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
		 Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_GRAVE)
		elseif not Duel.GetLocationCount(tp,LOCATION_SZONE)>1 and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>1 then
		 local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
		 Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_GRAVE)
		 end
end
function c511009345.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	local p=tc:GetControler()
	local c=e:GetHandler()
	if not tc then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(12152769,2))
		local g=Duel.SelectMatchingCard(tp,c511009345.eqfilter,tp,LOCATION_GRAVE,0,2,2,nil)
		local ec=g:GetFirst()
		while ec do
			Duel.HintSelection(g)
			Duel.MoveToField(ec,p,p,LOCATION_SZONE,POS_FACEUP,true)
			if not Duel.Equip(tp,ec,tc,true,true) then return end
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(c511009345.eqlimit)
			e1:SetLabelObject(tc)
			ec:RegisterEffect(e1)
			ec=g:GetNext()
		end
		Duel.EquipComplete()
	end
		
function c511009345.eqlimit(e,c)
	return c==e:GetLabelObject()
end

