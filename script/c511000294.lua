--Number C1000: Numerronius
function c511000294.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,12,5)
	c:EnableReviveLimit()
	--negate and cannot attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetTarget(c511000294.negfilter)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(c511000294.negfilter)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetTarget(c511000294.negfilter)
	c:RegisterEffect(e3)
	--Destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c511000294.desreptg)
	e4:SetOperation(c511000294.desrepop)
	c:RegisterEffect(e4)
	--destroy and summon C
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetDescription(aux.Stringid(511000294,2))
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCost(c511000294.descost)
	e5:SetTarget(c511000294.destg)
	e5:SetOperation(c511000294.desop)
	c:RegisterEffect(e5)
	--destroy and summon Battle
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e6:SetTarget(c511000294.des2tg)
	e6:SetOperation(c511000294.des2op)
	c:RegisterEffect(e6)
	--battle indestructable
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e7:SetValue(c511000294.indes)
	c:RegisterEffect(e7)
end
c511000294.xyz_number=1000
function c511000294.negfilter(e,c)
	return c:IsSetCard(0x1048) or c:IsSetCard(0x1073) or c:IsCode(511000296)
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
		local g=Duel.SelectMatchingCard(c511000294.repfilter,tp,LOCATION_MZONE,0,1,1,c)
		return true
	else return false end
end
function c511000294.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(c511000294.repfilter,tp,LOCATION_MZONE,0,1,1,c)
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
function c511000294.ssfilter(c,e,tp,tid)
	return c:GetTurnID()==tid and c:IsPreviousLocation(LOCATION_ONFIELD) 
	and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c511000294.des2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c511000294.des2op(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,nil)
	if Duel.Destroy(sg,REASON_EFFECT)~=0 then
	local tid=Duel.GetTurnCount()
	if Duel.IsExistingMatchingCard(c511000294.ssfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp,tid) then
	local g=Duel.GetMatchingGroup(c511000294.ssfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,e,tp,tid)
	if g:GetCount()>0 then
		local fc=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if g:GetCount()>fc then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			g=g:Select(tp,fc,fc,nil)
		end
		local tc=g:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
			tc=g:GetNext()
		end
		Duel.SpecialSummonComplete()
		end
		end
		end
end

function c511000294.indes(e,c)
	return not c:IsSetCard(0x48)
end