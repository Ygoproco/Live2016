--ＲＲ－アーセナル・ファルコン
--Raidraptor - Arsenal Falcon
--Scripted by Eerie Code
function c7677.initial_effect(c)
	aux.AddXyzProcedure(c,nil,7,2)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(7677,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c7677.spcost)
	e1:SetTarget(c7677.sptg)
	e1:SetOperation(c7677.spop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetValue(c7677.atkval)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(7677,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c7677.xcon)
	e3:SetTarget(c7677.xtg)
	e3:SetOperation(c7677.xop)
	c:RegisterEffect(e3)
end

function c7677.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c7677.spfil(c,e,tp)
	return c:GetLevel()==4 and c:IsRace(RACE_WINDBEAST) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c7677.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c7677.spfil,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c7677.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c7677.spfil,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c7677.atkval(e,c)
	local ct=c:GetOverlayGroup():FilterCount(Card.IsSetCard,nil,0xba)
	return math.max(0,ct-1)
end

function c7677.xcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():FilterCount(Card.IsSetCard,nil,0xba)>0
end
function c7677.xfil(c,e,tp)
	return c:IsSetCard(0xba) and c:IsType(TYPE_XYZ) and not c:IsCode(7677) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c7677.xtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c7677.xfil,tp,LOCATION_EXTRA,0,nil,e,tp)
	if chk==0 then 
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g:GetCount()>0
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_EXTRA)
end
function c7677.xop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c7677.xfil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local c=e:GetHandler()
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 and c:IsRelateToEffect(e) then
		Duel.Overlay(tc,Group.FromCards(c))
	end
end
