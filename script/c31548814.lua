--煉獄の狂宴
--Void Madness
--Scripted by Eerie Code
function c31548814.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c31548814.cost)
	e1:SetTarget(c31548814.tg)
	e1:SetOperation(c31548814.op)
	c:RegisterEffect(e1)
end

function c31548814.cfil(c)
	return c:IsSetCard(0xc5) and c:IsType(TYPE_SPELL+TYPE_TRAP) and (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsAbleToGraveAsCost()
end
function c31548814.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c31548814.cfil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,e:GetHandler())
	if chk==0 then return g:GetCount()>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:Select(tp,1,1,nil)
	Duel.SendtoGrave(sg,REASON_COST)
end
function c31548814.fil(c,e,tp,mg,lv,lc)
	if lc==0 then return false end
	local mg2=Group.CreateGroup()
	if mg then mg2=mg:Clone() end
	mg2:AddCard(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xbb) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
		and (not mg or not mg:IsContains(c))
		and (c:GetLevel()==lv or (c:GetLevel()<lv and lc>1 and Duel.IsExistingMatchingCard(c31548814.fil,tp,LOCATION_DECK,0,1,nil,e,tp,mg2,lv-c:GetLevel(),lc-1)))
end
function c31548814.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local lc=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then lc=math.min(lc,1) end
	lc=math.min(lc,3)
	local g=Duel.GetMatchingGroup(c31548814.fil,tp,LOCATION_DECK,0,nil,e,tp,nil,8,lc)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c31548814.op(e,tp,eg,ep,ev,re,r,rp)
	local lc=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then lc=math.min(lc,1) end
	lc=math.min(lc,3)
	if lc==0 then return end
	local g=Duel.GetMatchingGroup(c31548814.fil,tp,LOCATION_DECK,0,nil,e,tp,nil,8,lc)
	if g:GetCount()==0 then return end
	local lv=8
	local sg=Group.CreateGroup()
	while lv>0 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local mg=Duel.SelectMatchingCard(tp,c31548814.fil,tp,LOCATION_DECK,0,1,1,nil,e,tp,sg,lv,lc)
		local tc=mg:GetFirst()
		sg:AddCard(tc)
		lv=lv-tc:GetLevel()
		lc=lc-1
	end
	Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)
end
	