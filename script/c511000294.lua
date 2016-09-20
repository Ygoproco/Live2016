--Number C1000: Numerronius
function c511000294.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,12,5)
	c:EnableReviveLimit()
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(511000294,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(c511000294.negop)
	c:RegisterEffect(e1)
	--Destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c511000294.desreptg)
	e2:SetOperation(c511000294.desrepop)
	c:RegisterEffect(e2)
	--destroy and summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetDescription(aux.Stringid(511000294,2))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c511000294.descost)
	e3:SetTarget(c511000294.destg)
	e3:SetOperation(c511000294.desop)
	c:RegisterEffect(e3)
end
c511000294.xyz_number=1000
function c511000294.negfilter(c)
	return c:IsSetCard(0x1048) or c:IsSetCard(0x1073) or c:IsCode(511000296)
end
function c511000294.negop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c511000294.negfilter,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	local c=e:GetHandler()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CANNOT_ATTACK)
		tc:RegisterEffect(e3,true)
		tc=g:GetNext()
	end
end
function c511000294.repfilter(c)
	return c:IsDestructable() and not c:IsStatus(STATUS_DESTROY_CONFIRMED+STATUS_BATTLE_DESTROYED)
end
function c511000294.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) and c:IsOnField() and c:IsFaceup()
		and Duel.IsExistingMatchingCard(c511000294.repfilter,tp,LOCATION_MZONE,0,1,c) end
	if Duel.SelectYesNo(tp,aux.Stringid(511000294,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_MZONE,0,c)
		return true
	else return false end
end
function c511000294.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_MZONE,0,c)
	Duel.Destroy(g,REASON_EFFECT+REASON_REPLACE)
end
function c511000294.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c511000294.desfilter(c)
	return c:IsDestructable()
end
function c511000294.xyzfilter(c,e,tp)
	return (c:IsSetCard(0x1048) or c:IsSetCard(0x1073) or c:IsCode(511000296)) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c511000294.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return c511000294.filter(chkc) end
	if chk==0 then return (Duel.IsExistingTarget(c511000294.desfilter,tp,LOCATION_MZONE,0,1,c) and 
	Duel.IsExistingMatchingCard(c511000294.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)) or
	(Duel.IsExistingTarget(c511000294.desfilter,tp,0,LOCATION_MZONE,1,c) and 
	Duel.IsExistingMatchingCard(c511000294.xyzfilter,tp,0,LOCATION_EXTRA,1,nil,e,tp)) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=nil
	if (Duel.IsExistingTarget(c511000294.desfilter,tp,LOCATION_MZONE,0,1,c) and 
	Duel.IsExistingMatchingCard(c511000294.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)) and
	(Duel.IsExistingTarget(c511000294.desfilter,tp,0,LOCATION_MZONE,1,c) and 
	Duel.IsExistingMatchingCard(c511000294.xyzfilter,tp,0,LOCATION_EXTRA,1,nil,e,tp)) then
		g=Duel.SelectTarget(tp,c511000294.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,c)
	elseif (Duel.IsExistingTarget(c511000294.desfilter,tp,LOCATION_MZONE,0,1,c) and 
	Duel.IsExistingMatchingCard(c511000294.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)) then
		g=Duel.SelectTarget(tp,c511000294.desfilter,tp,LOCATION_MZONE,0,1,1,c)
	else
		g=Duel.SelectTarget(tp,c511000294.desfilter,tp,0,LOCATION_MZONE,1,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c511000294.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local p=e:GetHandler():GetControler()
	if tc:IsRelateToEffect(e) then
		if Duel.Destroy(tc,REASON_EFFECT)~=0 then
			local g=nil
			if tc:IsControler(p) then
				g=Duel.SelectMatchingCard(tp,c511000294.xyzfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
			else
				local g2=Duel.GetFieldGroup(p,0,LOCATION_EXTRA)
				Duel.ConfirmCards(p,g2)
				g=Duel.SelectMatchingCard(tp,c511000294.xyzfilter,tp,0,LOCATION_EXTRA,1,1,nil,e,tp)
			end
			if tc:IsControler(p) then
				Duel.SpecialSummonStep(g:GetFirst(),0,p,p,true,false,POS_FACEUP)
			else
				Duel.SpecialSummonStep(g:GetFirst(),0,p,1-p,true,false,POS_FACEUP)
			end
			Duel.SpecialSummonComplete()
		end
	end
end
