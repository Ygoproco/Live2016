--Wonder Recipe
function c511001089.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(511001089,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTarget(c511001089.target)
	e1:SetOperation(c511001089.operation)
	c:RegisterEffect(e1)
end
function c511001089.cfilter2(c)
	return c:IsFaceup() and c:IsCode(511001086) and c:GetOverlayCount()>0
end
function c511001089.filter(c,e,sp)
	return c:IsSetCard(0x1205) and c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function c511001089.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c511001089.cfilter2,tp,LOCATION_SZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c511001089.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function c511001089.operation(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local fc=Duel.SelectMatchingCard(tp,c511001089.cfilter2,tp,LOCATION_SZONE,0,1,1,nil):GetFirst()
	if fc:GetOverlayCount()<ft then ft=fc:GetOverlayCount() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c511001089.filter,tp,LOCATION_HAND,0,1,ft,nil,e,tp)
	if g:GetCount()>0 then
		Duel.HintSelection(Group.FromCards(fc))
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_ATTACK)
		Duel.Damage(1-tp,g:GetCount()*300,REASON_EFFECT)
	end
end
