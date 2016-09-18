--Scripted by Eerie Code
--Ancient Gear Chaos Fusion
function c700000034.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCost(c700000034.cost)
	e1:SetTarget(c700000034.target)
	e1:SetOperation(c700000034.activate)
	c:RegisterEffect(e1)
end

function c700000034.cfilter(c)
	return c:IsCode(24094653) and c:IsAbleToGraveAsCost()
end
function c700000034.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c700000034.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c700000034.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c700000034.spfilter(c,e,tp)
	if c:IsType(TYPE_FUSION) and c:IsSetCard(0x7) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) then
		local ft=c.material_count
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<ft then return false end
		local fm=Duel.GetMatchingGroup(c700000034.spmatfilter,tp,LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE,0,nil,e,tp)
		if not c:CheckFusionMaterial(fm,nil) then return false end
		return Duel.IsExistingMatchingCard(c700000034.rmfilter,tp,LOCATION_GRAVE,0,1,nil,tp,fm,c,ft-1)
	else return false end
end
function c700000034.spmatfilter(c,e,tp)
	return c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c700000034.rmfilter(c,tp,mats,fm,count)
	if c:GetSummonLocation()==LOCATION_EXTRA and c:IsPreviousLocation(LOCATION_MZONE) and c:IsAbleToRemoveAsCost() then
		local m=mats:Clone()
		if m:IsContains(c) then m:RemoveCard(c) end
		if count>0 then
			return fm:CheckFusionMaterial(m,nil) and Duel.IsExistingMatchingCard(c700000034.rmfilter,tp,LOCATION_GRAVE,0,1,nil,tp,m,fm,count-1)
		else
			return fm:CheckFusionMaterial(m,nil)
		end
	end
end
function c700000034.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2) 
		and Duel.IsExistingMatchingCard(c700000034.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
end
function c700000034.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local fg=Duel.SelectMatchingCard(tp,c700000034.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if fg:GetCount()==0 then return end
	local fm=fg:GetFirst()
	Duel.ConfirmCards(1-tp,fm)
	local fmc=fm.material_count
	local mg=Duel.GetMatchingGroup(c700000034.spmatfilter,tp,LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE,0,nil,e,tp)
	for i=1,fmc do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c700000034.rmfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp,mg,fm,fmc-i)
		if g:GetCount()==0 then return end
		local rc=g:GetFirst()
		mg:RemoveCard(rc)
		Duel.Remove(rc,POS_FACEUP,REASON_EFFECT+REASON_COST)
	end
	local mat1=Duel.SelectFusionMaterial(tp,fm,mg)
	local mc=mat1:GetFirst()
	while mc do
		Duel.SpecialSummonStep(mc,0,tp,tp,true,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		mc:RegisterEffect(e1)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		mc:RegisterEffect(e3)
		mc=mat1:GetNext()
	end
	Duel.SpecialSummonComplete()
	Duel.BreakEffect()
	fm:SetMaterial(mat1)
	Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
	Duel.BreakEffect()
	Duel.SpecialSummon(fm,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
end
