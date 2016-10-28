--オスティナート
--Ostinato
--Scripted by Eerie Code
function c7656.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c7656.con)
	e1:SetTarget(c7656.tg)
	e1:SetOperation(c7656.op)
	c:RegisterEffect(e1)
end

function c7656.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c7656.fil0(c,e,tp)
	return c:IsCanBeFusionMaterial() 
		and Duel.IsExistingMatchingCard(c7656.fil1,tp,LOCATION_HAND+LOCATION_DECK,0,1,c,e,tp,c)
end
function c7656.fil1(c,e,tp,mc)
	local mg=Group.FromCards(c,mc)
	return c:IsCanBeFusionMaterial()
		and Duel.IsExistingMatchingCard(c7656.fil2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg)
end
function c7656.fil2(c,e,tp,mg)
	return c:IsSetCard(0x9b) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
		and c:CheckFusionMaterial(mg,nil)
end
function c7656.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c7656.fil0,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c7656.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g1=Duel.SelectMatchingCard(tp,c7656.fil0,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	if g1:GetCount()==0 then return end
	local tc1=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g2=Duel.SelectMatchingCard(tp,c7656.fil1,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,tc1,e,tp,tc1)
	g1:Merge(g2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c7656.fil2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,g1)
	local tc=sg:GetFirst()
	tc:SetMaterial(g1)
	Duel.SendtoGrave(g1,REASON_MATERIAL+REASON_FUSION+REASON_EFFECT)
	Duel.BreakEffect()
	Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
	tc:CompleteProcedure()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(7656,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e1:SetOperation(c7656.desop)
	tc:RegisterEffect(e1,true)
end
function c7656.mgfilter(c,e,tp,fusc)
	return not c:IsControler(tp) or not c:IsLocation(LOCATION_GRAVE)
		or bit.band(c:GetReason(),0x40008)~=0x40008 or c:GetReasonCard()~=fusc
		or not c:IsCanBeSpecialSummoned(e,0,tp,false,false) or c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c7656.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
	local mg=tc:GetMaterial()
	local sumable=true
	local sumtype=tc:GetSummonType()
	if Duel.Destroy(tc,REASON_EFFECT)==0 or bit.band(sumtype,SUMMON_TYPE_FUSION)~=SUMMON_TYPE_FUSION or mg:GetCount()==0
		or mg:GetCount()>Duel.GetLocationCount(tp,LOCATION_MZONE)
		or mg:IsExists(c7656.mgfilter,1,nil,e,tp,tc,mg)
		or Duel.IsPlayerAffectedByEffect(tp,59822133) then
		sumable=false
	end
	if sumable and Duel.SelectYesNo(tp,aux.Stringid(7656,1)) then
		Duel.BreakEffect()
		Duel.SpecialSummon(mg,0,tp,tp,false,false,POS_FACEUP)
	end
end