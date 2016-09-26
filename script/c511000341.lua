--Dragon Evolution
function c511000341.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCost(c511000341.cost)
	e1:SetTarget(c511000341.target)
	e1:SetOperation(c511000341.activate)
	c:RegisterEffect(e1)
end
function c511000341.rfilter(c,e,tp)
	local lv=c:GetOriginalLevel()
	return lv>0 and c:IsRace(RACE_DRAGON) and c:IsReleasable()
end
function c511000341.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c511000341.rfilter,1,nil,e,tp) end
	local g=Duel.SelectReleaseGroup(tp,c511000341.rfilter,1,1,nil,e,tp)
	local tc=g:GetFirst()
	e:SetLabel(tc:GetOriginalLevel())
	Duel.Release(g,REASON_COST)
end
function c511000341.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c511000341.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
end
function c511000341.spfilter(c,e,tp,lv)
	return c:IsRace(RACE_DRAGON) and c:GetLevel()==lv+1 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c511000341.activate(e,tp,eg,ep,ev,re,r,rp)
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c511000341.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,lv)
	Duel.SpecialSummonStep(g:GetFirst(),0,tp,tp,false,false,POS_FACEUP)
	Duel.SpecialSummonComplete()
end
