--Number Return
function c511001576.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c511001576.condition)
	e1:SetTarget(c511001576.target)
	e1:SetOperation(c511001576.activate)
	c:RegisterEffect(e1)
end
function c511001576.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()==tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function c511001576.filter(c,e,tp)
	local ct=c.xyz_count
	return c:IsSetCard(0x48) and c:IsType(TYPE_XYZ) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and ct
		and Duel.IsExistingMatchingCard(c511001576.atfilter,tp,LOCATION_GRAVE,0,ct,c)
end
function c511001576.atfilter(c)
	return c:IsSetCard(0x48) and c:IsType(TYPE_MONSTER) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c511001576.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c511001576.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c511001576.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c511001576.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		local ct=tc.xyz_count
		local og=Duel.SelectMatchingCard(tp,c511001576.atfilter,tp,LOCATION_GRAVE,0,ct,ct,nil)
		Duel.Overlay(tc,og)
	end
end
